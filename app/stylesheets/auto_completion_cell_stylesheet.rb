module AutoCompletionCellStylesheet

  def auto_completion_cell_height
    40
  end

  def auto_completion_cell(st)
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_label(st)
    # st.color = color.white
  end

end
