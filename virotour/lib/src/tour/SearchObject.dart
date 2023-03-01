 class SearchObject{
  var _itemID;

  get itemID => _itemID;

  set itemID(value) {
    _itemID = value;
  }
  var _itemName;

  get itemName => _itemName;

  set itemName(value) {
    _itemName = value;
  }
  var _itemDescription;

  get itemDescription => _itemDescription;

  set itemDescription(value) {
    _itemDescription = value;
  }
  var _itemLocation;

  get itemLocation => _itemLocation;

  set itemLocation(value) {
    _itemLocation = value;
  } //url to the image in a tour
  SearchObject(var itemID, var itemName, var itemDescription, var itemLocation ){
    this.itemID=itemID;
    this.itemName = itemName;
    this.itemDescription = itemDescription;
    this.itemLocation = itemLocation;
  }
}