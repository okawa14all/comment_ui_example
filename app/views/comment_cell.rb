class CommentCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    @ttt_label = q.append(TTTAttributedLabel, :text).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(text)
    frame = @ttt_label.frame
    frame.size = CGSizeMake(rmq.stylesheet.text_area_width, 0)
    @ttt_label.setFrame(frame)

    # mention_matches is array of NSTextCheckingResult
    mention_matches = mention_regexp.matchesInString(
      text, options: 0, range: NSMakeRange(0, text.length))

    @ttt_label.setText(text, afterInheritingLabelAttributesAndConfiguringWithBlock:
      -> (mutable_attributed_string) {
        # set mention color and font
        mention_matches.each do |match|
          mutable_attributed_string.removeAttribute(
            KCTForegroundColorAttributeName, range: match.rangeAtIndex(0))
          mutable_attributed_string.addAttribute(
            KCTForegroundColorAttributeName,
            value: rmq.stylesheet.mention_color.CGColor, range: match.rangeAtIndex(0))

          mutable_attributed_string.removeAttribute(
            KCTFontAttributeName, range: match.rangeAtIndex(0))
          mutable_attributed_string.addAttribute(
            KCTFontAttributeName, value: mention_font, range: match.rangeAtIndex(0))
        end

        mutable_attributed_string
      }
    )

    @ttt_label.sizeToFit
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

  def mention_regexp
    @@mention_regexp ||= begin
      NSRegularExpression.regularExpressionWithPattern(
        '@[^:]+:\s',
        options: NSRegularExpressionCaseInsensitive,
        error: nil
      )
    end
  end

  def mention_font
    @@ref ||= CTFontCreateWithName(
      rmq.stylesheet.mention_font.fontName,
      rmq.stylesheet.mention_font.pointSize,
      nil
    )
  end

end
