class CommentCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    @text = q.append(UILabel, :text).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(text)
    frame = @text.frame
    frame.size = CGSizeMake(rmq.stylesheet.text_area_width, 0)
    @text.setFrame(frame)

    @text.text = text
    @text.sizeToFit
  end

  def self.height_for(text)
    modified_size = text.boundingRectWithSize(
      CGSizeMake(rmq.stylesheet.text_area_width, Float::MAX),
      options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine,
      attributes: {NSFontAttributeName => rmq.stylesheet.text_font},
      context: nil
    ).size

    h = modified_size.height + rmq.stylesheet.padding * 2
    h.ceil
  end

end
