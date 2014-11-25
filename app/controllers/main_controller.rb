class MainController < SLKTextViewController
  MENTION_PREFIX = '@'
  AUTO_COMPLETION_CELL_ID = "AutoCompletionCell"

  def init
    super.initWithTableViewStyle(UITableViewStylePlain)
    @users = %w(john paul ringo george jonathan ほげ)
    self
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    rmq.stylesheet = MainStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    # SLKTextViewController settings
    self.inverted = true
    self.textView.placeholder = 'comment...'
    self.textInputbar.maxCharCount = 140
    self.textInputbar.counterStyle = SLKCounterStyleSplit
    self.registerPrefixesForAutoCompletion([MENTION_PREFIX])
  end

  def init_nav
    self.title = 'Comment UI'
  end

  #---------- Overriden SLKTextViewController Methods ----------
  def didPressRightButton(sender)
    puts 'didPressRightButton'
    super
  end

  def canShowAutoCompletion
    prefix = self.foundPrefix
    word = self.foundWord
    @search_result = nil

    case prefix
    when MENTION_PREFIX
      @search_result =
        word.length > 0 ? @users.select{ |user| user.start_with?(word) } : @users
    end

    @search_result.present?
  end

  def heightForAutoCompletionView
    if @search_result.present?
      cell_height = self.tableView(
        self.autoCompletionView,
        heightForRowAtIndexPath: NSIndexPath.indexPathForRow(0, inSection:0)
      )
      cell_height * @search_result.size
    else
      0
    end
  end

  #---------- UITableView delegate ----------
  def numberOfSectionsInTableView(table_view)
    1
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    if table_view == self.autoCompletionView
      rmq.stylesheet.auto_completion_cell_height
    else
      0
    end
  end

  def tableView(table_view, numberOfRowsInSection: section)
    if table_view == self.autoCompletionView
      @search_result.present? ? @search_result.size : 0
    else
      0
    end
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    if table_view == self.autoCompletionView
      auto_completion_cell_for_row_at_index_path(index_path)
    else
      nil
    end
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    if table_view == self.autoCompletionView
      user_name = @search_result[index_path.row]
      self.acceptAutoCompletionWithString("#{user_name}: ")
    else
    end
  end

  def tableView(table_view, heightForHeaderInSection: section)
    if table_view == self.autoCompletionView
      rmq.stylesheet.auto_completion_view_header_height
    else
      0
    end
  end

  def tableView(table_view, viewForHeaderInSection: section)
    if table_view == self.autoCompletionView
      @auto_completion_view_header ||= UIView.new.tap do |header|
        header.backgroundColor = self.autoCompletionView.separatorColor
      end
    else
      nil
    end
  end

  private

  def auto_completion_cell_for_row_at_index_path(index_path)
    user_name = @search_result[index_path.row]

    cell = self.autoCompletionView.dequeueReusableCellWithIdentifier(AUTO_COMPLETION_CELL_ID) || begin
      rmq.create(
        AutoCompletionCell, :auto_completion_cell,
        reuse_identifier: AUTO_COMPLETION_CELL_ID,
        cell_style: UITableViewCellStyleDefault
      ).get
    end

    cell.update(user_name)

    cell
  end

end
