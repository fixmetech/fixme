/// Standard sizing constants for consistent spacing throughout the app
/// Following Material Design spacing guidelines with 8dp base unit
class FixMeSizes {
  FixMeSizes._(); // Private constructor to prevent instantiation

  // ============ SPACING & PADDING ============
  
  // Base spacing unit (8dp)
  static const double xs = 4.0;      // Extra small
  static const double sm = 8.0;      // Small
  static const double md = 16.0;     // Medium (default)
  static const double lg = 24.0;     // Large
  static const double xl = 32.0;     // Extra large
  static const double xxl = 48.0;    // Extra extra large

  // Component specific spacing
  static const double spaceBtwItems = 16.0;          // Space between list items
  static const double spaceBtwSections = 32.0;       // Space between sections
  static const double spaceBtwInputFields = 16.0;    // Space between form fields
  static const double spaceBtwButtons = 12.0;        // Space between buttons

  // ============ PADDING ============
  
  // Default padding
  static const double defaultSpace = 24.0;
  static const double cardPadding = 16.0;
  static const double screenPadding = 24.0;
  static const double containerPadding = 16.0;
  
  // Button padding
  static const double buttonPaddingVertical = 12.0;
  static const double buttonPaddingHorizontal = 24.0;
  
  // Input field padding
  static const double inputFieldPaddingVertical = 12.0;
  static const double inputFieldPaddingHorizontal = 16.0;
  
  // Card padding
  static const double cardPaddingVertical = 16.0;
  static const double cardPaddingHorizontal = 16.0;

  // ============ MARGINS ============
  
  // Page margins
  static const double pageMargin = 24.0;
  static const double sectionMargin = 32.0;
  static const double itemMargin = 16.0;
  
  // Component margins
  static const double buttonMargin = 8.0;
  static const double cardMargin = 16.0;
  static const double listItemMargin = 8.0;

  // ============ BORDER RADIUS ============
  
  static const double borderRadiusXs = 4.0;      // Extra small radius
  static const double borderRadiusSm = 8.0;      // Small radius
  static const double borderRadiusMd = 12.0;     // Medium radius (default)
  static const double borderRadiusLg = 16.0;     // Large radius
  static const double borderRadiusXl = 24.0;     // Extra large radius
  static const double borderRadiusCircle = 50.0; // Circular border

  // Component specific border radius
  static const double buttonBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double inputFieldBorderRadius = 12.0;
  static const double imageBorderRadius = 8.0;

  // ============ ICON SIZES ============
  
  static const double iconXs = 12.0;      // Extra small icon
  static const double iconSm = 16.0;      // Small icon
  static const double iconMd = 24.0;      // Medium icon (default)
  static const double iconLg = 32.0;      // Large icon
  static const double iconXl = 48.0;      // Extra large icon

  // ============ IMAGE SIZES ============
  
  static const double imageThumbSize = 80.0;      // Thumbnail
  static const double imageSmallSize = 120.0;     // Small image
  static const double imageMediumSize = 200.0;    // Medium image
  static const double imageLargeSize = 300.0;     // Large image
  static const double imageXLargeSize = 400.0;    // Extra large image

  // Profile image sizes
  static const double profileImageSm = 40.0;      // Small profile image
  static const double profileImageMd = 60.0;      // Medium profile image
  static const double profileImageLg = 80.0;      // Large profile image
  static const double profileImageXl = 120.0;     // Extra large profile image

  // ============ BUTTON SIZES ============
  
  static const double buttonHeight = 48.0;        // Standard button height
  static const double buttonHeightSm = 36.0;      // Small button height
  static const double buttonHeightLg = 56.0;      // Large button height
  static const double buttonWidth = 120.0;        // Minimum button width

  // ============ INPUT FIELD SIZES ============
  
  static const double inputFieldHeight = 56.0;    // Standard input field height
  static const double inputFieldHeightSm = 48.0;  // Small input field height
  static const double inputFieldHeightLg = 64.0;  // Large input field height

  // ============ CARD SIZES ============
  
  static const double cardElevation = 4.0;        // Standard card elevation
  static const double cardElevationSm = 2.0;      // Small card elevation
  static const double cardElevationLg = 8.0;      // Large card elevation

  // ============ APP BAR SIZES ============
  
  static const double appBarHeight = 56.0;        // Standard app bar height
  static const double appBarElevation = 4.0;      // App bar elevation

  // ============ BOTTOM NAVIGATION SIZES ============
  
  static const double bottomNavHeight = 60.0;     // Bottom navigation height
  static const double bottomNavElevation = 8.0;   // Bottom navigation elevation

  // ============ DIVIDER SIZES ============
  
  static const double dividerThickness = 1.0;     // Standard divider thickness
  static const double dividerIndent = 16.0;       // Divider indent

  // ============ LOADING INDICATOR SIZES ============
  
  static const double loadingIndicatorSm = 20.0;  // Small loading indicator
  static const double loadingIndicatorMd = 24.0;  // Medium loading indicator
  static const double loadingIndicatorLg = 32.0;  // Large loading indicator

  // ============ GRID SPACING ============
  
  static const double gridSpacing = 16.0;         // Grid item spacing
  static const double gridRunSpacing = 16.0;      // Grid run spacing
  static const double gridChildAspectRatio = 1.0; // Grid child aspect ratio

  // ============ LIST TILE SIZES ============
  
  static const double listTileHeight = 56.0;      // Standard list tile height
  static const double listTileHeightSm = 48.0;    // Small list tile height
  static const double listTileHeightLg = 64.0;    // Large list tile height
  static const double listTilePadding = 16.0;     // List tile padding

  // ============ DIALOG SIZES ============
  
  static const double dialogPadding = 24.0;       // Dialog padding
  static const double dialogMargin = 40.0;        // Dialog margin
  static const double dialogBorderRadius = 16.0;  // Dialog border radius

  // ============ SNACKBAR SIZES ============
  
  static const double snackbarPadding = 16.0;     // Snackbar padding
  static const double snackbarMargin = 8.0;       // Snackbar margin
  static const double snackbarBorderRadius = 8.0; // Snackbar border radius

  // ============ RESPONSIVE BREAKPOINTS ============
  
  static const double mobileBreakpoint = 768.0;   // Mobile breakpoint
  static const double tabletBreakpoint = 1024.0;  // Tablet breakpoint
  static const double desktopBreakpoint = 1200.0; // Desktop breakpoint
}