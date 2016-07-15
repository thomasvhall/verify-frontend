class VerifyFormBuilder < ActionView::Helpers::FormBuilder
  # Our custom radio button implementation. Workarounds:
  # 1. empty onclick attribute for iOS5 support
  # 2. blank space in the inner span to let JAWS-on-IE read the following text
  def block_label key, value, text, attributes = {}
    label "#{key}_#{value.to_s.parameterize}", class: 'block-label', onclick: '' do
      radio = radio_button key, value, attributes
      buffer_span = @template.content_tag(:span, @template.content_tag(:span, '&nbsp;'.html_safe, class: "inner"))
      radio + ' ' + buffer_span + ' ' + text
    end
  end
end
