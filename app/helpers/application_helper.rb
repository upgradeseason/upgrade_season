module ApplicationHelper
#Returns the full title on a per-page basis.
#Write test for full_title helper
  def full_title(page_title = '')
    base_title = "Upgrade Season"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
