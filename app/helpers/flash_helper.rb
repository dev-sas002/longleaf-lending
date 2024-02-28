module FlashHelper
  def flash_class_for(flash_type)
    case flash_type.to_sym
    when :notice
      "bg-green-500 border border-green-400 text-green-700"
    when :alert
      "bg-red-500 border border-red-400 text-red-700"
    else
      "bg-blue-500 border border-blue-400 text-blue-700"
    end
  end
end
