
module ActionView::Helpers::UrlHelper
	
	def confirm_javascript_function_with_modalbox(confirm_message, onclick, href = "javascript:function Z(){Z=\'\'}Z()")
		onclick = onclick.blank? ? '' : " onclick=\\\"#{escape_javascript(onclick)}\\\""
		"Modalbox.show(\"<div class='confirm'><p>#{escape_javascript(confirm_message)}</p> <a href='#{href}'#{onclick}>Yes</a> or <a href='javascript:none' onclick='Modalbox.hide()'>No</a></div>\", {title: (this.title == '' ? 'Confirm' : this.title), width: 300, autoFocusing: false});"
	end
	
	alias_method_chain :confirm_javascript_function, :modalbox
	
	def convert_options_to_javascript_with_modalbox!(html_options, url = '')
    confirm, popup = html_options.delete("confirm"), html_options.delete("popup")

    method, href = html_options.delete("method"), html_options['href']

    html_options["onclick"] = case
      when popup && method
        raise ActionView::ActionViewError, "You can't use :popup and :method in the same link"
      when confirm && popup
        "#{ confirm_javascript_function(confirm, popup_javascript_function(popup)) }; return false;"
      when confirm && method
        "#{ confirm_javascript_function(confirm, method_javascript_function(method)+" return false;", href || url) } return false;"
      when confirm
        "#{confirm_javascript_function(confirm, '', href || url )}; return false;"
      when method
        "#{method_javascript_function(method, url, href)}return false;"
      when popup
        popup_javascript_function(popup) + 'return false;'
      else
        html_options["onclick"]
    end
  end

	alias_method_chain :convert_options_to_javascript!, :modalbox
	
end

module ActionView::Helpers::PrototypeHelper
	
	def remote_function_with_modalbox(options)
		javascript_options = options_for_ajax(options)

		update = ''
		if options[:update] && options[:update].is_a?(Hash)
			update  = []
			update << "success:'#{options[:update][:success]}'" if options[:update][:success]
			update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
			update  = '{' + update.join(',') + '}'
		elsif options[:update]
			update << "'#{options[:update]}'"
		end

		function = update.empty? ? "new Ajax.Request(" : "new Ajax.Updater(#{update}, "

		url_options = options[:url]
		url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)
		function << "'#{url_for(url_options)}'"
		function << ", #{javascript_options})"

		function = "#{options[:before]}; #{function}" if options[:before]
		function = "#{function}; #{options[:after]}"  if options[:after]
		function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
		function = "Modalbox.show(\"<div class='confirm'><p>#{escape_javascript(options[:confirm])}</p> <a id='MB_confirm_yes' href='#' onclick=\\\"Modalbox.hide({afterHide: function() {#{function}}});\\\">Yes</a> or <a href='#' onclick='Modalbox.hide()' id='MB_confirm_no'>No</a></div>\", {title: (this.title == '' ? 'Confirm' : this.title), width: 300, autoFocusing: false})" if options[:confirm]

		return function
	end

	alias_method_chain :remote_function, :modalbox
	
end