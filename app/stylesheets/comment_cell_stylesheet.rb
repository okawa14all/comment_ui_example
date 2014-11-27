module CommentCellStylesheet
  def padding
    10
  end

  def text_area_width
    app_width - padding * 2
  end

  def text_font
    font.small
  end

  def comment_cell(st)
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def text(st)
    st.frame = { l: padding, t: padding, w: text_area_width, h: 0 }
    st.font = text_font
    st.color = color.gray
    st.number_of_lines = 0
    st.background_color = color.ivory
    st.line_break_mode = NSLineBreakByWordWrapping
    st.adjusts_font_size = false
  end

  def mention_color
    color.black
  end

  def mention_font
    font.bold_small
  end

end
