module BorrowersHelper


  def validation_error_messages!(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("error_validation_m",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="ui negative message attached">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end


end
