module ApplicationHelper
  # Returns the page title with the app name
  def page_title(title = nil)
    base = t('app.name')
    title.present? ? "#{title} | #{base}" : base
  end

  # Returns flash message CSS classes based on type
  def flash_class(type)
    case type.to_sym
    when :notice then 'bg-green-50 border-green-200 text-green-800'
    when :alert  then 'bg-red-50 border-red-200 text-red-800'
    when :info   then 'bg-blue-50 border-blue-200 text-blue-800'
    else 'bg-gray-50 border-gray-200 text-gray-800'
    end
  end
end
