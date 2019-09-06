# Delphi-InfiniteListViewScroll

The following is a simple project built with Delphi Rio 10.3.2 FMX demonstrating how to create an infinitely scrolling TListView in both directions.

Please note that this example doesn't come with any warranty, support or liabilities and should be used for reference purposes only.

The code has been tested on Win32.

**Description**

The app uses the ScrollViewChange event to track when the user is scrolling and when they scroll to within the start or end of the current list, it either adds new items to the end or inserts into the start.

To keep the relative position of the list the same after inserting new items at the start of the list, we adjust the scroll position to be the current scroll position + the total height of the new items we've added.

Note: After adding items to the list, the internal scroll caches need to be updated within TListView before it will allow us to scroll to the correct new position. To do this, we explicitly call .Paint() on the list view which forces the recalculation of the caches.

To use this example, you will need to replace the code in GenerateItems() with your own code.
This would ideally be converted into a TInfiniteListView component which I may do in future.

I hope this helps anyone else who needs to do this in Delphi.
