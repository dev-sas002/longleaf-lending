import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["step", "input"]

  connect() {
    this.showCurrentStep()
  }

  nextStep(event) {
    event.preventDefault()
    if (this.validateForm()) {
      const currentStep = this.currentStep()
      const nextStep = currentStep + 1
      if (nextStep <= this.stepTargets.length) {
        this.setCurrentStep(nextStep)
        this.showCurrentStep()
      } else {
        this.submitForm()
      }
    }
  }

  validateForm() {
    const input = this.inputTargets[this.currentStep() - 1]
    const isValid = input.checkValidity()
    if (!isValid) {
      input.reportValidity()
    }
    return isValid
  }

  async submitForm() {
    const form = this.element;
    const formData = new FormData(form)

    const response = await fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      }
    })

    this.element.querySelectorAll('.flash').forEach(flash => {
      setTimeout(() => {
        flash.style.transition = 'opacity 0.5s';
        flash.style.opacity = '0';
      }, 3000); 

      flash.addEventListener('transitionend', () => {
        flash.remove();
      });
    });
    const data = await response.json()

    debugger;
    const errors = data.errors;
    let errorMessages = "";
    if(!errors) {
      location.reload();
    } else {
      errors.forEach((error) => {
        errorMessages += `<p class='text-red-500 text-sm'>${error}</p>`
      }) 
      document.querySelector("#model-errors").innerHTML = errorMessages;
    }
  }

  previousStep(event) {
    event.preventDefault()
    const currentStep = this.currentStep()
    const previousStep = currentStep - 1
    if (previousStep >= 1) {
      this.setCurrentStep(previousStep)
      this.showCurrentStep()
    }
  }

  showCurrentStep() {
    const currentStep = this.currentStep()
    this.stepTargets.forEach((element, index) => {
      element.classList.toggle("hidden", index !== currentStep - 1)
    })
    const steps = document.querySelectorAll('[class^="step-"]');
    steps.forEach((element, index) => {
      if (currentStep - 1 !== index ) {
        element.classList.remove('text-green-500')
      } else {
        element.classList.add('text-green-500')
      }
    });
    if (currentStep < this.stepTargets.length) {
      document.querySelector("#forward-btn").innerText = 'Next'
    } else {
      document.querySelector("#forward-btn").innerText = 'Submit'
    }
    document.querySelector('.progress-bar').style.width = currentStep < 6 ? `${16 * currentStep}%` : '100%'
  }

  currentStep() {
    return parseInt(this.data.get("currentStepValue"))
  }

  setCurrentStep(step) {
    this.data.set("currentStepValue", step)
  }
}
