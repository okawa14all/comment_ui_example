class MainStylesheet < ApplicationStylesheet
  include AutoCompletionCellStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def auto_completion_view_header_height
    0.5
  end

end
