module ApplicationHelper
  def full_title page_title
    base_title = t "base_title"
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end

  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      type = "error" if type == "danger"
      text = "<script>toastr.#{type}('#{message}', '',
        {closeButton: true, progressBar: true})</script>"
      flash_messages << text if message
    end.join "\n"
  end
end
