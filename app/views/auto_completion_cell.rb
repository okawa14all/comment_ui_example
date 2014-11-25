class AutoCompletionCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)
    @name = q.build(self.textLabel, :cell_label).get

    if self.respondsToSelector('layoutMargins')
      self.layoutMargins = UIEdgeInsetsZero
    end
  end

  def update(name)
    @name.text = name
  end

end
