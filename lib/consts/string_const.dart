class StringConst {
  /*HomePage*/
  static const String poIn = "Pending\norder";
  static const String poOut = "Pick Up";
  static const String locationShifting = "Location\n shift";
  static const String sale = "Sale";
  static const String info = "Info";
  static const String chalan = "Chalan";
  static const String chalanreturn = "Chalan Return";
  static const String chalanReturndrop = "Chalan Return Drop";
  static const String salereturn = "Sale Return";
  static const String salereturndrop = "Sale Return Drop";
  static const String bulkDrop = "Bulk Drop";
  static const String singleDrop = "Single Drop";
  static const String getPackInfo = "Pack Info";
  static const String serialInfo = "Serial Info";

  static const String poDrop = "Drop";
  static const String poAudit = "Audit";
  static const String openingStock = "Opening\n Stock";
  static const String transfer = "Transfer\norder";
  static const String appName = "Soori Warehouses";

  /*Login Page*/
  static String loginWelcome = "Welcome !";
  static String loginText = " Login to";
  static String soori = " SOORI";
  static String account = " Account";
  static String rememberMe = "Remember Me";
  static String userName = 'Username';
  static String password = 'Password';
  static String subDomain = 'subDomain';

  /*Network */
  static String mainUrl = '';
  // static String branchUrl = 'http://192.168.101.19:8081/api/v1/branches';
  // static String branchUrl = 'http://default.api.v1.soori.ims.merakitechs.com/api/v1/branches';
  // static String branchUrl =
  //     'https://api.sooritechnology.com.np/api/v1/branches';
  static String branchUrl =
      'https://api-soori-ims-staging.dipendranath.com.np/api/v1/branches';
  // static String baseUrl = 'https://api-soori-ims-staging.dipendranath.com.np';
  static const String refreshToken = "user-app/login/refresh";
  static const String logout = "user-app/logout";
  static String baseUrl = "https://api.sooritechnology.com.np";
  /*http://192.168.101.13:8000/api/v1/branches*/
  static String urlMidPoint = '/api/v1/user-app/';
  static String customerList = "/api/v1/chalan-app/customer-list?limit=0";
  static String getPackCodes =
      "/api/v1/customer-order-app/batch-save-pickup-order";
  static String pickupVerify =
      '/api/v1/customer-order-app/verify-pickup-customer-order';
  static const String allNotification =
      "api/v1/notification-app/user-notification?limit=0&ordering=-created_date_ad";
  static const String notificationCount =
      "api/v1/notification-app/user-notification/count";
  static const String notificationReceive =
      "api/v1/notification-app/user-notification/receive";
  static const String readAllNotification = "api/v1/notification-app/user-notification/read-all";
  static String pendingPurchaseSummary = "/api/v1/purchase-app/";
  static String chalanReturnDrop =
      '/api/v1/chalan-app/chalan-master-returned?offset=0&limit=0&return_dropped=false';
  static String chalanReturn =
      '/api/v1/chalan-app/chalan-master-returned?search=&offset=0&limit=0';
  static String chalanReturnView =
      '/api/v1/chalan-app/chalan-detail?chalan_master=';
  static String chalanReturnDropUpdate =
      '/api/v1/chalan-app/chalan-return-drop';
  static String chalanReturnAddChalanNo =
      '/api/v1/chalan-app/chalan-master-chalan?';
  static String chalanReturnDropScanNow =
      '/api/v1/chalan-app/chalan-return-info?limit=0&chalan_master=';
  static String chalanReturnDropScanService =
      '/api/v1/chalan-app/chalan-return-drop';
  static String saleReturn = '/api/v1/sale-app/sale-master-return';
  static String saleReturnView =
      '/api/v1/sale-app/sale-detail?limit=0&sale_master=';
  static String saleReturnDrop =
      '/api/v1/sale-app/sale-master-return?offset=0&limit=0&return_dropped=false';
  static String urlPurchaseApp = '/api/v1/purchase-app/';
  static String urlPurchaseAppList = '/api/v1/purchase-app/get-orders';
  static String bulkDropApi = '/api/v1/purchase-app/location-bulk-purchase-order-details';
  static String receivePurchaseOrder = '/api/v1/purchase-app/receive-purchase-order';
  static String urlAuditApp = '/api/v1/audit-app/';
  static String urlCustomerOrderApp = '/api/v1/customer-order-app/';
  static String urlOpeningStockApp = '/api/v1/opening-stock-app/';
  static String locationShiftingApi =
      '/api/v1/item-serialization-app/update-pack-location';
  static String locationShiftingGetId =
      '/api/v1/item-serialization-app/pack-code-location/';
  static String packInfoGetData = '/api/v1/item-serialization-app/pack-code-info/';
  static String serialInfoGetData = '/api/v1/item-serialization-app/serial-no-info/';
  static String transferMaster= "/api/v1/transfer-app/";
  static String pickupDetail= "/api/v1/transfer-app/pack-type?purchase_detail=";
  static String getSerialCode= "/api/v1/transfer-app/pack-type-detail?";
  static String postPickupTransfer= "/api/v1/transfer-app/pickup-transfer";

  /*For Headers*/
  static const contentType = 'application/json; charset=UTF-8';
  static const xRequestedWith = 'XMLHttpRequest';
  static String bearerAuthToken = 'BearerAuthToken';

  /*Others*/
  static String pendingOrders = 'Pending Orders';
  static String purchaseOrdersDetail = 'Purchase Order Details';
  static String selectBranch = 'Select Branch';

  static var somethingWrongMsg = '';
  static String loading = 'Loading...';

  static String updateSerialNumber = 'Update Serial Numbers';

  static String pQty = 'purchaseQty';
  static String pItem = 'purchaseItem';
  static String pPackingType = 'purchasePackingType';
  static String pPackingTypeDetail = 'purchaseTypeDetail';
  static String pRefPurchaseOrderDetail = 'purchaseRefPurchaseOrderDetail';
  static String pTotalUnitBoxes = 'totalUnitBoxes';

  static String pSerialNo = "purchaseSerialNo";

  static String packSerialNo = "Serial No";

  static String saveButton = 'SAVE';
  static String updateButton = 'UPDATE';
  static String packingType = 'Packing Type';

  static String noDataAvailable = 'No Data Available';

  static String serverErrorMsg = 'We ran into problem, Please Try Again';

/*Drop Items*/
  static String dropOrders = 'Drop Received Orders';
  static String bulkdropOrders = 'Bulk Drop Received Orders';
  static String dropOrdersDetail = 'Drop Order Details';
  static String bulkdropOrdersDetail = 'Bulk Drop Order Details';
  static String dropOrderID = 'dropID';

  /*PickUp*/
  static String pickOrders = 'Pickup Orders';
  static String pickUpOrderID = 'pickUpOrderID';
  static String pickUpOrdersDetail = 'Pickup Details';
  static String pickUpSavedPackCodesID = 'pickUpSavedPackCodesID';
  static String pickUpsSavedItemID = 'pickUpsSavedItemID';
  static String pickUpsScannedIndex = 'pickUpsScannedIndex';

  /*Opening Stock*/
  static String openingStocks = 'Opening Stocks ';
  static String openingStockDetail = 'Opening Stock Details';
  static String openingStockOrderID = 'openStockID';

// static String dropReceivedOrderUrl  = 'http://192.168.101.13:8000/api/v1/purchase-app/get-orders/received';

}
