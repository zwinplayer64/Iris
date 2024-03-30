--!optimize 2
-- lib/lua
type ID = string

type Argument = any
type Arguments = {
    [string]: Argument,
    Text: string,
    TextHint: string,
    Wrapped: boolean,
    Color: Color3,
    RichText: boolean,

    Increment: InputDataType,
    Min: InputDataType,
    Max: InputDataType,
    Format: { string },
    UseFloats: boolean,
    UseHSV: boolean,
    UseHex: boolean,
    Prefix: { string },

    Width: number,
    VerticalAlignment: Enum.VerticalAlignment,
    Index: any,

    SpanAvailWidth: boolean,
    NoIdent: boolean,
    NoClick: boolean,
    NoButtons: boolean,
    NoButton: boolean,
    NoPreview: boolean,

    NumColumns: number,
    RowBg: boolean,
    BordersOuter: boolean,
    BordersInner: boolean,

    Title: string,
    NoTitleBar: boolean,
    NoBackground: boolean,
    NoCollapse: boolean,
    NoClose: boolean,
    NoMove: boolean,
    NoScrollbar: boolean,
    NoResize: boolean,
    NoMenu: boolean,

    KeyCode: Enum.KeyCode,
    ModifierKey: Enum.ModifierKey,
    Disabled: boolean,
}

type State = {
    value: any,
    ConnectedWidgets: { [ID]: string },
    ConnectedFunctions: { (any) -> () },

    get: (self: State) -> any,
    set: (self: State, newValue: any) -> (),
    onChange: (self: State, funcToConnect: (any) -> ()) -> (),
}

type States = {
    [string]: State,
    number: State,
    color: State,
    transparency: State,
    editingText: State,
    index: State,

    size: State,
    position: State,
    progress: State,
    scrollDistance: State,

    isChecked: State,
    isOpened: State,
    isUncollapsed: State,
}

type Event = {
    Init: (Widget) -> (),
    Get: (Widget) -> boolean,
}
type Events = { [string]: Event }

type EventAPI = () -> boolean

type InputDataType = number | Vector2 | Vector3 | UDim | UDim2 | Color3 | Rect | { number }
type InputDataTypes = "Num" | "Vector2" | "Vector3" | "UDim" | "UDim2" | "Color3" | "Color4" | "Rect" | "Enum" | "" | string

type WidgetArguments = { [number]: Argument }
type WidgetStates = {
    number: State?,
    color: State?,
    transparency: State?,
    editingText: State?,
    index: State?,

    size: State?,
    position: State?,
    scrollDistance: State?,

    isChecked: State?,
    isOpened: State?,
    isUncollapsed: State?,

    [string]: State,
}

type Widget = {
    ID: ID,
    type: string,
    state: States,
    lastCycleTick: number,
    trackedEvents: {},

    parentWidget: Widget,
    Instance: GuiObject,
    ChildContainer: GuiObject,
    Disabled: boolean,
    arguments: Arguments,
    providedArguments: Arguments,
    ZIndex: number,

    usesScreenGUI: boolean,
    ButtonColors: { [string]: Color3 | number },
    ComboChildrenHeight: number,

    -- Table properties
    RowColumnIndex: number,
    InitialNumColumns: number,
    ColumnInstances: { Frame },
    CellInstances: { Frame },

    -- Event Props
    isHoveredEvent: boolean,

    lastClickedTick: number,
    lastClickedTime: number,
    lastClickedPosition: Vector2,

    lastRightClickedTick: number,
    lastDoubleClickedTick: number,
    lastCtrlClickedTick: number,

    lastCheckedTick: number,
    lastUncheckedTick: number,
    lastOpenedTick: number,
    lastClosedTick: number,
    lastSelectedTick: number,
    lastUnselectedTick: number,
    lastCollapsedTick: number,
    lastUncollapsedTick: number,

    lastNumberChangedTick: number,
    lastTextchangeTick: number,
    lastShortcutTick: number,

    -- Events
    hovered: EventAPI,
    clicked: EventAPI,
    rightClicked: EventAPI,
    ctrlClicked: EventAPI,
    doubleClicked: EventAPI,

    checked: EventAPI,
    unchecked: EventAPI,
    activated: EventAPI,
    deactivated: EventAPI,
    collapsed: EventAPI,
    uncollapsed: EventAPI,
    selected: EventAPI,
    unselected: EventAPI,
    opened: EventAPI,
    closed: EventAPI,

    active: EventAPI,

    numberChanged: EventAPI,
    textChanged: EventAPI,

    [string]: EventAPI & State,
}

type WidgetClass = {
    Generate: (thisWidget: Widget) -> GuiObject,
    Discard: (thisWidget: Widget) -> (),
    Update: (thisWidget: Widget, ...any) -> (),

    Args: { [string]: number },
    Events: Events,
    hasChildren: boolean,
    hasState: boolean,
    ArgNames: { [number]: string },

    GenerateState: (thisWidget: Widget) -> (),
    UpdateState: (thisWidget: Widget) -> (),

    ChildAdded: (thisWidget: Widget, thisChild: Widget) -> GuiObject,
    ChildDiscarded: (thisWidget: Widget, thisChild: Widget) -> (),
}

type WidgetUtility = {
    GuiService: GuiService,
    RunService: RunService,
    TextService: TextService,
    UserInputService: UserInputService,
    ContextActionService: ContextActionService,

    getTime: () -> number,
    getMouseLocation: () -> Vector2,

    ICONS: {
        RIGHT_POINTING_TRIANGLE: string,
        DOWN_POINTING_TRIANGLE: string,
        MULTIPLICATION_SIGN: string,
        BOTTOM_RIGHT_CORNER: string,
        CHECK_MARK: string,
        ALPHA_BACKGROUND_TEXTURE: string,
    },

    GuiInset: Vector2,

    findBestWindowPosForPopup: (refPos: Vector2, size: Vector2, outerMin: Vector2, outerMax: Vector2) -> Vector2,
    getScreenSizeForWindow: (thisWidget: Widget) -> Vector2,
    isPosInsideRect: (pos: Vector2, rectMin: Vector2, rectMax: Vector2) -> boolean,
    extend: (superClass: WidgetClass, { [any]: any }) -> WidgetClass,
    discardState: (thisWidget: Widget) -> (),

    UIPadding: (Parent: GuiObject, PxPadding: Vector2) -> UIPadding,
    UIListLayout: (Parent: GuiObject, FillDirection: Enum.FillDirection, Padding: UDim) -> UIListLayout,
    UIStroke: (Parent: GuiObject, Thickness: number, Color: Color3, Transparency: number) -> UIStroke,
    UICorner: (Parent: GuiObject, PxRounding: number?) -> UICorner,
    UISizeConstraint: (Parent: GuiObject, MinSize: Vector2?, MaxSize: Vector2?) -> UISizeConstraint,
    UIReference: (Parent: GuiObject, Child: GuiObject, Name: string) -> ObjectValue,

    calculateTextSize: (text: string, width: number?) -> Vector2,
    applyTextStyle: (thisInstance: TextLabel | TextButton | TextBox) -> (),
    applyInteractionHighlights: (thisWidget: Widget, Button: GuiButton, Highlightee: GuiObject, Colors: { [string]: any }) -> (),
    applyInteractionHighlightsWithMultiHighlightee: (thisWidget: Widget, Button: GuiButton, Highlightees: { { GuiObject | { [string]: Color3 | number } } }) -> (),
    applyTextInteractionHighlights: (thisWidget: Widget, Button: GuiButton, Highlightee: TextLabel | TextButton | TextBox, Colors: { [string]: any }) -> (),
    applyFrameStyle: (thisInstance: GuiObject, forceNoPadding: boolean?, doubleyNoPadding: boolean?) -> (),

    applyButtonClick: (thisWidget: Widget, thisInstance: GuiButton, callback: () -> ()) -> (),
    applyButtonDown: (thisWidget: Widget, thisInstance: GuiButton, callback: (x: number, y: number) -> ()) -> (),
    applyMouseEnter: (thisWidget: Widget, thisInstance: GuiObject, callback: () -> ()) -> (),
    applyMouseLeave: (thisWidget: Widget, thisInstance: GuiObject, callback: () -> ()) -> (),
    applyInputBegan: (thisWidget: Widget, thisInstance: GuiObject, callback: (input: InputObject) -> ()) -> (),
    applyInputEnded: (thisWidget: Widget, thisInstance: GuiObject, callback: (input: InputObject) -> ()) -> (),

    registerEvent: (event: string, callback: (...any) -> ()) -> (),

    EVENTS: {
        hover: (pathToHovered: (thisWidget: Widget) -> GuiObject) -> Event,
        click: (pathToClicked: (thisWidget: Widget) -> GuiButton) -> Event,
        rightClick: (pathToClicked: (thisWidget: Widget) -> GuiButton) -> Event,
        doubleClick: (pathToClicked: (thisWidget: Widget) -> GuiButton) -> Event,
        ctrlClick: (pathToClicked: (thisWidget: Widget) -> GuiButton) -> Event,
    },

    abstractButton: WidgetClass,
}

type Internal = {
    --[[
        --------------
          PROPERTIES
        --------------
    ]]
    _version: string,
    _started: boolean,
    _shutdown: boolean,
    _cycleTick: number,
    _eventConnection: RBXScriptConnection?,

    -- Refresh
    _globalRefreshRequested: boolean,
    _localRefreshActive: boolean,

    -- Widgets & Instances
    _widgets: { [string]: WidgetClass },
    _widgetCount: number,
    _stackIndex: number,
    _rootInstance: GuiObject?,
    _rootWidget: Widget,
    _lastWidget: Widget,
    SelectionImageObject: Frame,
    parentInstance: BasePlayerGui,
    _utility: WidgetUtility,

    -- Config
    _rootConfig: Config,
    _config: Config,

    -- ID
    _IDStack: { ID },
    _usedIDs: { [ID]: number },
    _pushedId: ID?,
    _nextWidgetId: ID?,

    -- VDOM
    _lastVDOM: { [ID]: Widget },
    _VDOM: { [ID]: Widget },

    -- State
    _states: { [ID]: State },

    -- Callback
    _postCycleCallbacks: { () -> () },
    _connectedFunctions: { () -> () },
    _connections: { RBXScriptConnection },
    _initFunctions: { () -> () },
    _cycleCoroutine: thread?,

    --[[
        ---------
          STATE
        ---------
    ]]

    StateClass: {
        __index: any,

        get: (self: State) -> any,
        set: (self: State, newValue: any) -> any,
        onChange: (self: State, callback: (newValue: any) -> ()) -> (),
    },

    --[[
        -------------
          FUNCTIONS
        -------------
    ]]
    _cycle: () -> (),
    _NoOp: () -> (),

    -- Widget
    WidgetConstructor: (type: string, widgetClass: WidgetClass) -> (),
    _Insert: (widgetType: string, arguments: WidgetArguments?, states: WidgetStates?) -> Widget,
    _GenNewWidget: (widgetType: string, arguments: Arguments, states: WidgetStates?, ID: ID) -> Widget,
    _ContinueWidget: (ID: ID, widgetType: string) -> Widget,
    _DiscardWidget: (widgetToDiscard: Widget) -> (),

    _widgetState: (thisWidget: Widget, stateName: string, initialValue: any) -> State,
    _EventCall: (thisWidget: Widget, eventName: string) -> boolean,
    _GetParentWidget: () -> Widget,
    SetFocusedWindow: (thisWidget: Widget?) -> (),

    -- Generate
    _generateEmptyVDOM: () -> { [ID]: Widget },
    _generateRootInstance: () -> (),
    _generateSelectionImageObject: () -> (),

    -- Utility
    _getID: (levelsToIgnore: number) -> ID,
    _deepCompare: (t1: {}, t2: {}) -> boolean,
    _deepCopy: (t: {}) -> {},
}

type Iris = {
    --[[
        -----------
          WIDGETS
        -----------
    ]]

    End: () -> (),

    -- Window API
    Window: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    Tooltip: (arguments: WidgetArguments) -> Widget,

    -- Menu Widget API
    MenuBar: () -> Widget,
    Menu: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    MenuItem: (arguments: WidgetArguments) -> Widget,
    MenuToggle: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Format Widget API
    Separator: () -> Widget,
    Indent: (arguments: WidgetArguments?) -> Widget,
    SameLine: (arguments: WidgetArguments?) -> Widget,
    Group: () -> Widget,

    -- Text Widget API
    Text: (arguments: WidgetArguments) -> Widget,
    TextWrapped: (arguments: WidgetArguments) -> Widget,
    TextColored: (arguments: WidgetArguments) -> Widget,
    SeparatorText: (arguments: WidgetArguments) -> Widget,
    InputText: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Basic Widget API
    Button: (arguments: WidgetArguments) -> Widget,
    SmallButton: (arguments: WidgetArguments) -> Widget,
    Checkbox: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    RadioButton: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Tree Widget API
    Tree: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    CollapsingHeader: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Input Widget API
    InputNum: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputVector2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputVector3: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputUDim: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputUDim2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputRect: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputColor3: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    InputColor4: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Drag Widget API
    DragNum: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    DragVector2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    DragVector3: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    DragUDim: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    DragUDim2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    DragRect: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Slider Widget API
    SliderNum: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderVector2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderVector3: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderUDim: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderUDim2: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderRect: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    SliderEnum: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Combo Widget Widget API
    Selectable: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    Combo: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,
    ComboArray: (arguments: WidgetArguments, states: WidgetStates?, selectionArray: { any }) -> Widget,
    ComboEnum: (arguments: WidgetArguments, states: WidgetStates?, enumType: Enum) -> Widget,
    InputEnum: (arguments: WidgetArguments, states: WidgetStates?, enumType: Enum) -> Widget,

    ProgressBar: (arguments: WidgetArguments, states: WidgetStates?) -> Widget,

    -- Table Widget Api
    Table: (arguments: WidgetArguments) -> Widget,
    NextColumn: () -> (),
    SetColumnIndex: (columnIndex: number) -> (),
    NextRow: () -> (),

    --[[
        ---------
          STATE
        ---------
    ]]

    State: (initialValue: any) -> State,
    WeakState: (initialValue: any) -> State,
    ComputedState: (firstState: State, onChangeCallback: (firstState: any) -> any) -> State,

    --[[
        -------------
          FUNCTIONS
        -------------
    ]]

    Init: (playerInstance: BasePlayerGui?, eventConnection: (RBXScriptConnection | () -> ())?) -> Iris,
    Shutdown: () -> (),
    Connect: (self: Iris, callback: () -> ()) -> (),
    Append: (userInstance: GuiObject) -> (),
    ForceRefresh: () -> (),

    -- Widget
    SetFocusedWindow: (thisWidget: Widget?) -> (),

    -- ID API
    PushId: (id: ID) -> (),
    PopId: (id: ID) -> (),
    SetNextWidgetID: (id: ID) -> (),

    -- Config API
    UpdateGlobalConfig: (deltaStyle: { [string]: any }) -> (),
    PushConfig: (deltaStyle: { [string]: any }) -> (),
    PopConfig: () -> (),

    --[[
        --------------
          PROPERTIES
        --------------
    ]]

    Internal: Internal,
    Disabled: boolean,
    Args: { [string]: { [string]: number } },
    Events: { [string]: () -> boolean },

    TemplateConfig: { [string]: Config },
    _config: Config,
    ShowDemoWindow: () -> Widget,
}

type Config = {
    TextColor: Color3,
    TextTransparency: number,
    TextDisabledColor: Color3,
    TextDisabledTransparency: number,

    BorderColor: Color3,
    BorderActiveColor: Color3,
    BorderTransparency: number,
    BorderActiveTransparency: number,

    WindowBgColor: Color3,
    WindowBgTransparency: number,
    ScrollbarGrabColor: Color3,
    ScrollbarGrabTransparency: number,

    TitleBgColor: Color3,
    TitleBgTransparency: number,
    TitleBgActiveColor: Color3,
    TitleBgActiveTransparency: number,
    TitleBgCollapsedColor: Color3,
    TitleBgCollapsedTransparency: number,

    MenubarBgColor: Color3,
    MenubarBgTransparency: number,

    FrameBgColor: Color3,
    FrameBgTransparency: number,
    FrameBgHoveredColor: Color3,
    FrameBgHoveredTransparency: number,
    FrameBgActiveColor: Color3,
    FrameBgActiveTransparency: number,

    ButtonColor: Color3,
    ButtonTransparency: number,
    ButtonHoveredColor: Color3,
    ButtonHoveredTransparency: number,
    ButtonActiveColor: Color3,
    ButtonActiveTransparency: number,

    SliderGrabColor: Color3,
    SliderGrabTransparency: number,
    SliderGrabActiveColor: Color3,
    SliderGrabActiveTransparency: number,

    HeaderColor: Color3,
    HeaderTransparency: number,
    HeaderHoveredColor: Color3,
    HeaderHoveredTransparency: number,
    HeaderActiveColor: Color3,
    HeaderActiveTransparency: number,

    SelectionImageObjectColor: Color3,
    SelectionImageObjectTransparency: number,
    SelectionImageObjectBorderColor: Color3,
    SelectionImageObjectBorderTransparency: number,

    TableBorderStrongColor: Color3,
    TableBorderStrongTransparency: number,
    TableBorderLightColor: Color3,
    TableBorderLightTransparency: number,
    TableRowBgColor: Color3,
    TableRowBgTransparency: number,
    TableRowBgAltColor: Color3,
    TableRowBgAltTransparency: number,

    NavWindowingHighlightColor: Color3,
    NavWindowingHighlightTransparency: number,
    NavWindowingDimBgColor: Color3,
    NavWindowingDimBgTransparency: number,

    SeparatorColor: Color3,
    SeparatorTransparency: number,

    CheckMarkColor: Color3,
    CheckMarkTransparency: number,

    PlotHistogramColor: Color3,
    PlotHistogramTransparency: number,
    PlotHistogramHoveredColor: Color3,
    PlotHistogramHoveredTransparency: number,

    HoverColor: Color3,
    HoverTransparency: number,

    -- Sizes
    ItemWidth: UDim,
    ContentWidth: UDim,

    WindowPadding: Vector2,
    WindowResizePadding: Vector2,
    FramePadding: Vector2,
    ItemSpacing: Vector2,
    ItemInnerSpacing: Vector2,
    CellPadding: Vector2,
    DisplaySafeAreaPadding: Vector2,
    IndentSpacing: number,
    SeparatorTextPadding: Vector2,

    TextFont: Font,
    TextSize: number,
    FrameBorderSize: number,
    FrameRounding: number,
    GrabRounding: number,
    WindowBorderSize: number,
    WindowTitleAlign: Enum.LeftRight,
    PopupBorderSize: number,
    PopupRounding: number,
    ScrollbarSize: number,
    GrabMinSize: number,
    SeparatorTextBorderSize: number,

    UseScreenGUIs: boolean,
    IgnoreGuiInset: boolean,
    Parent: BasePlayerGui,
    RichText: boolean,
    TextWrapped: boolean,
    DisableWidget: boolean,
    DisplayOrderOffset: number,
    ZIndexOffset: number,

    MouseDoubleClickTime: number,
    MouseDoubleClickMaxDist: number,
    MouseDragThreshold: number,
}
--------------------------------------------------------------------------------------------
-- lib/config.lua
local TemplateConfig = {
    colorDark = { -- Dear, ImGui default dark
        TextColor = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0,
        TextDisabledColor = Color3.fromRGB(128, 128, 128),
        TextDisabledTransparency = 0,

        BorderColor = Color3.fromRGB(110, 110, 125),
        -- Dear ImGui uses 110, 110, 125
        -- The Roblox window selection highlight is 67, 191, 254
        BorderActiveColor = Color3.fromRGB(160, 160, 175), -- does not exist in Dear ImGui

        BorderTransparency = 0,
        BorderActiveTransparency = 0,
        -- BorderTransparency will be problematic for non UIStroke border implimentations
        -- is not implimented because of this

        WindowBgColor = Color3.fromRGB(15, 15, 15),
        WindowBgTransparency = 0.072,

        ScrollbarGrabColor = Color3.fromRGB(128, 128, 128),
        ScrollbarGrabTransparency = 0,

        TitleBgColor = Color3.fromRGB(10, 10, 10),
        TitleBgTransparency = 0,
        TitleBgActiveColor = Color3.fromRGB(41, 74, 122),
        TitleBgActiveTransparency = 0,
        TitleBgCollapsedColor = Color3.fromRGB(0, 0, 0),
        TitleBgCollapsedTransparency = 0.5,

        MenubarBgColor = Color3.fromRGB(36, 36, 36),
        MenubarBgTransparency = 0,

        FrameBgColor = Color3.fromRGB(41, 74, 122),
        FrameBgTransparency = 0.46,
        FrameBgHoveredColor = Color3.fromRGB(66, 150, 250),
        FrameBgHoveredTransparency = 0.46,
        FrameBgActiveColor = Color3.fromRGB(66, 150, 250),
        FrameBgActiveTransparency = 0.33,

        ButtonColor = Color3.fromRGB(66, 150, 250),
        ButtonTransparency = 0.6,
        ButtonHoveredColor = Color3.fromRGB(66, 150, 250),
        ButtonHoveredTransparency = 0,
        ButtonActiveColor = Color3.fromRGB(15, 135, 250),
        ButtonActiveTransparency = 0,

        SliderGrabColor = Color3.fromRGB(66, 150, 250),
        SliderGrabTransparency = 0,
        SliderGrabActiveColor = Color3.fromRGB(117, 138, 204),
        SliderGrabActiveTransparency = 0,

        HeaderColor = Color3.fromRGB(66, 150, 250),
        HeaderTransparency = 0.69,
        HeaderHoveredColor = Color3.fromRGB(66, 150, 250),
        HeaderHoveredTransparency = 0.2,
        HeaderActiveColor = Color3.fromRGB(66, 150, 250),
        HeaderActiveTransparency = 0,

        SelectionImageObjectColor = Color3.fromRGB(255, 255, 255),
        SelectionImageObjectTransparency = 0.8,
        SelectionImageObjectBorderColor = Color3.fromRGB(255, 255, 255),
        SelectionImageObjectBorderTransparency = 0,

        TableBorderStrongColor = Color3.fromRGB(79, 79, 89),
        TableBorderStrongTransparency = 0,
        TableBorderLightColor = Color3.fromRGB(59, 59, 64),
        TableBorderLightTransparency = 0,
        TableRowBgColor = Color3.fromRGB(0, 0, 0),
        TableRowBgTransparency = 1,
        TableRowBgAltColor = Color3.fromRGB(255, 255, 255),
        TableRowBgAltTransparency = 0.94,

        NavWindowingHighlightColor = Color3.fromRGB(255, 255, 255),
        NavWindowingHighlightTransparency = 0.3,
        NavWindowingDimBgColor = Color3.fromRGB(204, 204, 204),
        NavWindowingDimBgTransparency = 0.65,

        SeparatorColor = Color3.fromRGB(110, 110, 128),
        SeparatorTransparency = 0.5,

        CheckMarkColor = Color3.fromRGB(66, 150, 250),
        CheckMarkTransparency = 0,

        PlotHistogramColor = Color3.fromRGB(230, 179, 0),
        PlotHistogramTransparency = 0,
        PlotHistogramHoveredColor = Color3.fromRGB(255, 153, 0),
        PlotHistogramHoveredTransparency = 0,
    },
    colorLight = { -- Dear, ImGui default light
        TextColor = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0,
        TextDisabledColor = Color3.fromRGB(153, 153, 153),
        TextDisabledTransparency = 0,

        BorderColor = Color3.fromRGB(64, 64, 64),
        -- Dear ImGui uses 0, 0, 0, 77
        -- The Roblox window selection highlight is 67, 191, 254
        BorderActiveColor = Color3.fromRGB(64, 64, 64), -- does not exist in Dear ImGui

        -- BorderTransparency = 0.5,
        -- BorderTransparency will be problematic for non UIStroke border implimentations
        -- will not be implimented because of this

        WindowBgColor = Color3.fromRGB(240, 240, 240),
        WindowBgTransparency = 0,

        TitleBgColor = Color3.fromRGB(245, 245, 245),
        TitleBgTransparency = 0,
        TitleBgActiveColor = Color3.fromRGB(209, 209, 209),
        TitleBgActiveTransparency = 0,
        TitleBgCollapsedColor = Color3.fromRGB(255, 255, 255),
        TitleBgCollapsedTransparency = 0.5,

        MenubarBgColor = Color3.fromRGB(219, 219, 219),
        MenubarBgTransparency = 0,

        ScrollbarGrabColor = Color3.fromRGB(96, 96, 96),
        ScrollbarGrabTransparency = 0,

        FrameBgColor = Color3.fromRGB(255, 255, 255),
        FrameBgTransparency = 0.6,
        FrameBgHoveredColor = Color3.fromRGB(66, 150, 250),
        FrameBgHoveredTransparency = 0.6,
        FrameBgActiveColor = Color3.fromRGB(66, 150, 250),
        FrameBgActiveTransparency = 0.33,

        ButtonColor = Color3.fromRGB(66, 150, 250),
        ButtonTransparency = 0.6,
        ButtonHoveredColor = Color3.fromRGB(66, 150, 250),
        ButtonHoveredTransparency = 0,
        ButtonActiveColor = Color3.fromRGB(15, 135, 250),
        ButtonActiveTransparency = 0,

        HeaderColor = Color3.fromRGB(66, 150, 250),
        HeaderTransparency = 0.31,
        HeaderHoveredColor = Color3.fromRGB(66, 150, 250),
        HeaderHoveredTransparency = 0.2,
        HeaderActiveColor = Color3.fromRGB(66, 150, 250),
        HeaderActiveTransparency = 0,

        SliderGrabColor = Color3.fromRGB(61, 133, 224),
        SliderGrabTransparency = 0,
        SliderGrabActiveColor = Color3.fromRGB(66, 150, 250),
        SliderGrabActiveTransparency = 0,

        SelectionImageObjectColor = Color3.fromRGB(0, 0, 0),
        SelectionImageObjectTransparency = 0.8,
        SelectionImageObjectBorderColor = Color3.fromRGB(0, 0, 0),
        SelectionImageObjectBorderTransparency = 0,

        TableBorderStrongColor = Color3.fromRGB(145, 145, 163),
        TableBorderStrongTransparency = 0,
        TableBorderLightColor = Color3.fromRGB(173, 173, 189),
        TableBorderLightTransparency = 0,
        TableRowBgColor = Color3.fromRGB(0, 0, 0),
        TableRowBgTransparency = 1,
        TableRowBgAltColor = Color3.fromRGB(77, 77, 77),
        TableRowBgAltTransparency = 0.91,

        NavWindowingHighlightColor = Color3.fromRGB(179, 179, 179),
        NavWindowingHighlightTransparency = 0.3,
        NavWindowingDimBgColor = Color3.fromRGB(51, 51, 51),
        NavWindowingDimBgTransparency = 0.8,

        SeparatorColor = Color3.fromRGB(99, 99, 99),
        SeparatorTransparency = 0.38,

        CheckMarkColor = Color3.fromRGB(66, 150, 250),
        CheckMarkTransparency = 0,

        PlotHistogramColor = Color3.fromRGB(230, 179, 0),
        PlotHistogramTransparency = 0,
        PlotHistogramHoveredColor = Color3.fromRGB(255, 153, 0),
        PlotHistogramHoveredTransparency = 0,
    },

    sizeDefault = { -- Dear, ImGui default
        ItemWidth = UDim.new(1, 0),
        ContentWidth = UDim.new(0.65, 0),

        WindowPadding = Vector2.new(8, 8),
        WindowResizePadding = Vector2.new(6, 6),
        FramePadding = Vector2.new(4, 3),
        ItemSpacing = Vector2.new(8, 4),
        ItemInnerSpacing = Vector2.new(4, 4),
        CellPadding = Vector2.new(4, 2),
        DisplaySafeAreaPadding = Vector2.new(0, 0),
        SeparatorTextPadding = Vector2.new(20, 3),
        IndentSpacing = 21,

        TextFont = Font.fromEnum(Enum.Font.Code),
        TextSize = 13,
        FrameBorderSize = 0,
        FrameRounding = 0,
        GrabRounding = 0,
        WindowRounding = 0, -- these don't actually work but it's nice to have them.
        WindowBorderSize = 1,
        WindowTitleAlign = Enum.LeftRight.Left,
        PopupBorderSize = 1,
        PopupRounding = 0,
        ScrollbarSize = 7,
        GrabMinSize = 10,
        SeparatorTextBorderSize = 3,
    },
    sizeClear = { -- easier to read and manuveure
        ItemWidth = UDim.new(1, 0),
        ContentWidth = UDim.new(0.65, 0),

        WindowPadding = Vector2.new(12, 8),
        WindowResizePadding = Vector2.new(8, 8),
        FramePadding = Vector2.new(6, 4),
        ItemSpacing = Vector2.new(8, 8),
        ItemInnerSpacing = Vector2.new(8, 8),
        CellPadding = Vector2.new(4, 4),
        DisplaySafeAreaPadding = Vector2.new(8, 8),
        SeparatorTextPadding = Vector2.new(24, 6),
        IndentSpacing = 25,

        TextFont = Font.fromEnum(Enum.Font.Ubuntu),
        TextSize = 15,
        FrameBorderSize = 1,
        FrameRounding = 4,
        GrabRounding = 4,
        WindowRounding = 4,
        WindowBorderSize = 1,
        WindowTitleAlign = Enum.LeftRight.Center,
        PopupBorderSize = 1,
        PopupRounding = 4,
        ScrollbarSize = 9,
        GrabMinSize = 14,
        SeparatorTextBorderSize = 4,
    },

    utilityDefault = {
        UseScreenGUIs = true,
        IgnoreGuiInset = false,
        Parent = nil,
        RichText = false,
        TextWrapped = false,
        DisableWidget = false, -- currently unused
        DisplayOrderOffset = 127,
        ZIndexOffset = 0,

        MouseDoubleClickTime = 0.30, -- Time for a double-click, in seconds.
        MouseDoubleClickMaxDist = 6.0, -- Distance threshold to stay in to validate a double-click, in pixels.

        HoverColor = Color3.fromRGB(255, 255, 0),
        HoverTransparency = 0.1,
    },
}
--------------------------------------------------------------------------------------------
-- lib/demoWindow.lua
local demoWindow = (function()
	return function(Iris: Iris)
		local showMainWindow = Iris.State(true)
		local showRecursiveWindow = Iris.State(false)
		local showRuntimeInfo = Iris.State(false)
		local showStyleEditor = Iris.State(false)
		local showWindowlessDemo = Iris.State(false)
		local showMainMenuBarWindow = Iris.State(false)

		-- stylua: ignore start
		local function helpMarker(helpText)
			Iris.PushConfig({ TextColor = Iris._config.TextDisabledColor })
			local text = Iris.Text({ "(?)" })
			Iris.PopConfig()

			Iris.PushConfig({ ContentWidth = UDim.new(0, 350) })
			if text.hovered() then
				Iris.Tooltip({ helpText })
			end
			Iris.PopConfig()
		end

		-- shows each widgets functionality
		local widgetDemos = {
			Basic = function()
				Iris.Tree({ "Basic" })
					Iris.SeparatorText({ "Basic" })

					local radioButtonState = Iris.State(1)
					Iris.Button({ "Button" })
					Iris.SmallButton({ "SmallButton" })
					Iris.Text({ "Text" })
					Iris.TextWrapped({ string.rep("Text Wrapped ", 5) })
					Iris.TextColored({ "Colored Text", Color3.fromRGB(255, 128, 0) })
					Iris.Text({ `Rich Text: <b>bold text</b> <i>italic text</i> <u>underline text</u> <s>strikethrough text</s> <font color= "rgb(240, 40, 10)">red text</font> <font size="32">bigger text</font>`, true, nil, true })
					Iris.SameLine()
						Iris.RadioButton({ "Index '1'", 1 }, { index = radioButtonState })
						Iris.RadioButton({ "Index 'two'", "two" }, { index = radioButtonState })
						if Iris.RadioButton({ "Index 'false'", false }, { index = radioButtonState }).active() == false then
							if Iris.SmallButton({ "Select last" }).clicked() then
								radioButtonState:set(false)
							end
						end
					Iris.End()
					Iris.Text({ "The Index is: " .. tostring(radioButtonState.value) })

					Iris.SeparatorText({ "Inputs" })

					Iris.InputNum({})
					Iris.DragNum({})
					Iris.SliderNum({})

				Iris.End()
			end,

			Tree = function()
				Iris.Tree({ "Trees" })
					Iris.Tree({ "Tree using SpanAvailWidth", [Iris.Args.Tree.SpanAvailWidth] = true })
						helpMarker("SpanAvailWidth determines if the Tree is selectable from its entire with, or only the text area")
					Iris.End()

					local tree1 = Iris.Tree({ "Tree with Children" })
						Iris.Text({ "Im inside the first tree!" })
						Iris.Button({ "Im a button inside the first tree!" })
						Iris.Tree({ "Im a tree inside the first tree!" })
							Iris.Text({ "I am the innermost text!" })
						Iris.End()
					Iris.End()

					Iris.Checkbox({ "Toggle above tree" }, { isChecked = tree1.state.isUncollapsed })

				Iris.End()
			end,

			CollapsingHeader = function()
				Iris.Tree({ "Collapsing Headers" })
					Iris.CollapsingHeader({ "A header" })
						Iris.Text({ "This is under the first header!" })
					Iris.End()

					local secondHeader = Iris.State(true)
					Iris.CollapsingHeader({ "Another header" }, { isUncollapsed = secondHeader })
						if Iris.Button({ "Shhh... secret button!" }).clicked() then
							secondHeader:set(true)
						end
					Iris.End()
				Iris.End()
			end,

			Group = function()
				Iris.Tree({ "Groups" })
					Iris.SameLine()
						Iris.Group()
							Iris.Text({ "I am in group A" })
							Iris.Button({ "Im also in A" })
						Iris.End()
						
						Iris.Separator()
						
						Iris.Group()
							Iris.Text({ "I am in group B" })
							Iris.Button({ "Im also in B" })
							Iris.Button({ "Also group B" })
						Iris.End()
					Iris.End()
				Iris.End()
			end,

			Indent = function()
				Iris.Tree({ "Indents" })
					Iris.Text({ "Not Indented" })
					Iris.Indent()
						Iris.Text({ "Indented" })
						Iris.Indent({ 7 })
							Iris.Text({ "Indented by 7 more pixels" })
						Iris.End()

						Iris.Indent({ -7 })
							Iris.Text({ "Indented by 7 less pixels" })
						Iris.End()
					Iris.End()
				Iris.End()
			end,

			Input = function()
				Iris.Tree({ "Input" })
					local NoField, NoButtons, Min, Max, Increment, Format = Iris.State(false), Iris.State(false), Iris.State(0), Iris.State(100), Iris.State(1), Iris.State("%d")

					Iris.PushConfig({ ContentWidth = UDim.new(1, -120) })
					local InputNum = Iris.InputNum({
						"Input Number",
						-- [Iris.Args.InputNum.NoField] = NoField.value,
						[Iris.Args.InputNum.NoButtons] = NoButtons.value,
						[Iris.Args.InputNum.Min] = Min.value,
						[Iris.Args.InputNum.Max] = Max.value,
						[Iris.Args.InputNum.Increment] = Increment.value,
						[Iris.Args.InputNum.Format] = { Format.value },
					})
					Iris.PopConfig()
					Iris.Text({ "The Value is: " .. InputNum.number.value })
					if Iris.Button({ "Randomize Number" }).clicked() then
						InputNum.number:set(math.random(1, 99))
					end
					local NoFieldCheckbox = Iris.Checkbox({ "NoField" }, { isChecked = NoField })
					local NoButtonsCheckbox = Iris.Checkbox({ "NoButtons" }, { isChecked = NoButtons })
					if NoFieldCheckbox.checked() and NoButtonsCheckbox.isChecked.value == true then
						NoButtonsCheckbox.isChecked:set(false)
					end
					if NoButtonsCheckbox.checked() and NoFieldCheckbox.isChecked.value == true then
						NoFieldCheckbox.isChecked:set(false)
					end

					Iris.PushConfig({ ContentWidth = UDim.new(1, -120) })
					Iris.InputVector2({ "InputVector2" })
					Iris.InputVector3({ "InputVector3" })
					Iris.InputUDim({ "InputUDim" })
					Iris.InputUDim2({ "InputUDim2" })
					local UseFloats = Iris.State(false)
					local UseHSV = Iris.State(false)
					local sharedColor = Iris.State(Color3.new())
					local transparency = Iris.State(0)
					Iris.SliderNum({ "Transparency", 0.01, 0, 1 }, { number = transparency })
					Iris.InputColor3({ "InputColor3", UseFloats:get(), UseHSV:get() }, { color = sharedColor })
					Iris.InputColor4({ "InputColor4", UseFloats:get(), UseHSV:get() }, { color = sharedColor, transparency = transparency })
					Iris.SameLine()
						Iris.Text({ sharedColor:get():ToHex() })
						Iris.Checkbox({ "Use Floats" }, { isChecked = UseFloats })
						Iris.Checkbox({ "Use HSV" }, { isChecked = UseHSV })
					Iris.End()

					Iris.PopConfig()

					Iris.Separator()

					Iris.SameLine()
						Iris.Text({ "Slider Numbers" })
						helpMarker("ctrl + click slider number widgets to input a number")
					Iris.End()
					Iris.PushConfig({ ContentWidth = UDim.new(1, -120) })
					Iris.SliderNum({ "Slide Int", 1, 1, 8 })
					Iris.SliderNum({ "Slide Float", 0.01, 0, 100 })
					Iris.SliderNum({ "Small Numbers", 0.001, -2, 1, "%f radians" })
					Iris.SliderNum({ "Odd Ranges", 0.001, -math.pi, math.pi, "%f radians" })
					Iris.SliderNum({ "Big Numbers", 1e4, 1e5, 1e7 })
					Iris.SliderNum({ "Few Numbers", 1, 0, 3 })
					Iris.PopConfig()

					Iris.Separator()

					Iris.SameLine()
						Iris.Text({ "Drag Numbers" })
						helpMarker("ctrl + click or double click drag number widgets to input a number, hold shift/alt while dragging to increase/decrease speed")
					Iris.End()
					Iris.PushConfig({ ContentWidth = UDim.new(1, -120) })
					Iris.DragNum({ "Drag Int" })
					Iris.DragNum({ "Slide Float", 0.001, -10, 10 })
					Iris.DragNum({ "Percentage", 1, 0, 100, "%d %%" })
					Iris.PopConfig()
				Iris.End()
			end,

			InputText = function()
				Iris.Tree({ "Input Text" })
					local InputText = Iris.InputText({ "Input Text Test", [Iris.Args.InputText.TextHint] = "Input Text here" })
					Iris.Text({ "The text is: " .. InputText.text.value })
				Iris.End()
			end,

			MultiInput = function()
				Iris.Tree({"Multi-Component Input"})

					local sharedVector2 = Iris.State(Vector2.new())
					local sharedVector3 = Iris.State(Vector3.new())
					local sharedUDim = Iris.State(UDim.new())
					local sharedUDim2 = Iris.State(UDim2.new())
					local sharedColor3 = Iris.State(Color3.new())
					local SharedRect = Iris.State(Rect.new(0, 0, 0, 0))

					Iris.SeparatorText({"Input"})

					Iris.InputVector2({}, {number = sharedVector2})
					Iris.InputVector3({}, {number = sharedVector3})
					Iris.InputUDim({}, {number = sharedUDim})
					Iris.InputUDim2({}, {number = sharedUDim2})
					Iris.InputRect({}, {number = SharedRect})

					Iris.SeparatorText({"Drag"})

					Iris.DragVector2({}, {number = sharedVector2})
					Iris.DragVector3({}, {number = sharedVector3})
					Iris.DragUDim({}, {number = sharedUDim})
					Iris.DragUDim2({}, {number = sharedUDim2})
					Iris.DragRect({}, {number = SharedRect})

					Iris.SeparatorText({"Slider"})

					Iris.SliderVector2({}, {number = sharedVector2})
					Iris.SliderVector3({}, {number = sharedVector3})
					Iris.SliderUDim({}, {number = sharedUDim})
					Iris.SliderUDim2({}, {number = sharedUDim2})
					Iris.SliderRect({}, {number = SharedRect})

					Iris.SeparatorText({"Color"})

					Iris.InputColor3({}, {color = sharedColor3})
					Iris.InputColor4({}, {color = sharedColor3})

				Iris.End()
			end,

			Tooltip = function()
				Iris.PushConfig({ ContentWidth = UDim.new(0, 250) })
				Iris.Tree({ "Tooltip" })
					if Iris.Text({ "Hover over me to reveal a tooltip" }).hovered() then
						Iris.Tooltip({ "I am some helpful tooltip text" })
					end
					local dynamicText = Iris.State("Hello ")
					local numRepeat = Iris.State(1)
					if Iris.InputNum({ "# of repeat", 1, 1, 50 }, { number = numRepeat }).numberChanged() then
						dynamicText:set(string.rep("Hello ", numRepeat:get()))
					end
					if Iris.Checkbox({ "Show dynamic text tooltip" }).isChecked.value then
						Iris.Tooltip({ dynamicText:get() })
					end
				Iris.End()
				Iris.PopConfig()
			end,

			Selectable = function()
				Iris.Tree({ "Selectable" })
					local sharedIndex = Iris.State(2)
					Iris.Selectable({ "Selectable #1", 1 }, { index = sharedIndex })
					Iris.Selectable({ "Selectable #2", 2 }, { index = sharedIndex })
					if Iris.Selectable({ "Double click Selectable", 3, true }, { index = sharedIndex }).doubleClicked() then
						sharedIndex:set(3)
					end
					Iris.Selectable({ "Impossible to select", 4, true }, { index = sharedIndex })
					if Iris.Button({ "Select last" }).clicked() then
						sharedIndex:set(4)
					end
					Iris.Selectable({ "Independent Selectable" })
				Iris.End()
			end,

			Combo = function()
				Iris.Tree({ "Combo" })
					Iris.PushConfig({ ContentWidth = UDim.new(1, -120) })
					local sharedComboIndex = Iris.State("No Selection")
					Iris.SameLine()
						local NoPreview = Iris.Checkbox({ "No Preview" })
						local NoButton = Iris.Checkbox({ "No Button" })
						if NoPreview.checked() and NoButton.isChecked.value == true then
							NoButton.isChecked:set(false)
						end
						if NoButton.checked() and NoPreview.isChecked.value == true then
							NoPreview.isChecked:set(false)
						end
					Iris.End()
					Iris.Combo({ "Basic Usage", NoButton.isChecked:get(), NoPreview.isChecked:get() }, { index = sharedComboIndex })
						Iris.Selectable({ "Select 1", "One" }, { index = sharedComboIndex })
						Iris.Selectable({ "Select 2", "Two" }, { index = sharedComboIndex })
						Iris.Selectable({ "Select 3", "Three" }, { index = sharedComboIndex })
					Iris.End()

					Iris.ComboArray({ "Using ComboArray" }, { index = "No Selection" }, { "Red", "Green", "Blue" })

					local sharedComboIndex2 = Iris.State("7 AM")
					Iris.Combo({ "Combo with Inner widgets" }, { index = sharedComboIndex2 })
						Iris.Tree({ "Morning Shifts" })
							Iris.Selectable({ "Shift at 7 AM", "7 AM" }, { index = sharedComboIndex2 })
							Iris.Selectable({ "Shift at 11 AM", "11 AM" }, { index = sharedComboIndex2 })
							Iris.Selectable({ "Shist at 3 PM", "3 PM" }, { index = sharedComboIndex2 })
						Iris.End()
						Iris.Tree({ "Night Shifts" })
							Iris.Selectable({ "Shift at 6 PM", "6 PM" }, { index = sharedComboIndex2 })
							Iris.Selectable({ "Shift at 9 PM", "9 PM" }, { index = sharedComboIndex2 })
						Iris.End()
					Iris.End()

					local ComboEnum = Iris.ComboEnum({ "Using ComboEnum" }, { index = Enum.UserInputState.Begin }, Enum.UserInputState)
					Iris.Text({ "Selected: " .. ComboEnum.index:get().Name })
					Iris.PopConfig()
				Iris.End()
			end,

			Plotting = function()
				Iris.Tree({"Plotting"})
					local curTime = time() * 15

					local Progress = Iris.State(0)
					-- formula to cycle between 0 and 100 linearly
					local newValue = math.clamp((math.abs(curTime % 100 - 50)) - 7.5, 0, 35) / 35
					Progress:set(newValue)
	
					Iris.ProgressBar({ "Progress Bar" }, { progress = Progress })
					Iris.ProgressBar({ "Progress Bar", `{math.floor(Progress:get() * 1753)}/1753` }, { progress = Progress })
				Iris.End()
			end,
		}
		local widgetDemosOrder = { "Basic", "Tree", "CollapsingHeader", "Group", "Indent", "Input", "MultiInput", "InputText", "Tooltip", "Selectable", "Combo", "Plotting"}

		local function recursiveTree()
			local theTree = Iris.Tree({ "Recursive Tree" })
			if theTree.state.isUncollapsed.value then
				recursiveTree()
			end
			Iris.End()
		end

		local function recursiveWindow(parentCheckboxState)
			Iris.Window({ "Recursive Window" }, { size = Iris.State(Vector2.new(175, 100)), isOpened = parentCheckboxState })
				local theCheckbox = Iris.Checkbox({ "Recurse Again" })
			Iris.End()
			if theCheckbox.isChecked.value then
				recursiveWindow(theCheckbox.isChecked)
			end
		end

		-- shows list of runtime widgets and states, including IDs. shows other info about runtime and can show widgets/state info in depth.
		local function runtimeInfo()
			local runtimeInfoWindow = Iris.Window({ "Runtime Info" }, { isOpened = showRuntimeInfo })
				local lastVDOM = Iris.Internal._lastVDOM
				local states = Iris.Internal._states

				local numSecondsDisabled = Iris.State(3)
				local rollingDT = Iris.State(0)
				local lastT = Iris.State(os.clock())

				Iris.SameLine()
					Iris.InputNum({ "", [Iris.Args.InputNum.Format] = "%d Seconds", [Iris.Args.InputNum.Max] = 10 }, { number = numSecondsDisabled })
					if Iris.Button({ "Disable" }).clicked() then
						Iris.Disabled = true
						task.delay(numSecondsDisabled:get(), function()
							Iris.Disabled = false
						end)
					end
				Iris.End()

				local t = os.clock()
				local dt = t - lastT.value
				rollingDT.value += (dt - rollingDT.value) * 0.2
				lastT.value = t
				Iris.Text({ string.format("Average %.3f ms/frame (%.1f FPS)", rollingDT.value * 1000, 1 / rollingDT.value) })

				Iris.Text({
					string.format("Window Position: (%d, %d), Window Size: (%d, %d)", runtimeInfoWindow.position.value.X, runtimeInfoWindow.position.value.Y, runtimeInfoWindow.size.value.X, runtimeInfoWindow.size.value.Y),
				})

				Iris.SameLine()
					Iris.Text({ "Enter an ID to learn more about it." })
					helpMarker("every widget and state has an ID which Iris tracks to remember which widget is which. below lists all widgets and states, with their respective IDs")
				Iris.End()

				Iris.PushConfig({ ItemWidth = UDim.new(1, -150) })
				local enteredText = Iris.InputText({ "ID field" }, { text = Iris.State(runtimeInfoWindow.ID) }).text.value
				Iris.PopConfig()

				Iris.Indent()
					local enteredWidget = lastVDOM[enteredText]
					local enteredState = states[enteredText]
					if enteredWidget then
						Iris.Table({ 1, [Iris.Args.Table.RowBg] = false })
							Iris.Text({ string.format('The ID, "%s", is a widget', enteredText) })
							Iris.NextRow()

							Iris.Text({ string.format("Widget is type: %s", enteredWidget.type) })
							Iris.NextRow()

							Iris.Tree({ "Widget has Args:" }, { isUncollapsed = Iris.State(true) })
								for i, v in enteredWidget.arguments do
									Iris.Text({ i .. " - " .. tostring(v) })
								end
							Iris.End()
							Iris.NextRow()

							if enteredWidget.state then
								Iris.Tree({ "Widget has State:" }, { isUncollapsed = Iris.State(true) })
									for i, v in enteredWidget.state do
										Iris.Text({ i .. " - " .. tostring(v.value) })
									end
								Iris.End()
							end
						Iris.End()
					elseif enteredState then
						Iris.Table({ 1, [Iris.Args.Table.RowBg] = false })
							Iris.Text({ string.format('The ID, "%s", is a state', enteredText) })
							Iris.NextRow()

							Iris.Text({ string.format("Value is type: %s, Value = %s", typeof(enteredState.value), tostring(enteredState.value)) })
							Iris.NextRow()

							Iris.Tree({ "state has connected widgets:" }, { isUncollapsed = Iris.State(true) })
								for i, v in enteredState.ConnectedWidgets do
									Iris.Text({ i .. " - " .. v.type })
								end
							Iris.End()
							Iris.NextRow()

							Iris.Text({ string.format("state has: %d connected functions", #enteredState.ConnectedFunctions) })
						Iris.End()
					else
						Iris.Text({ string.format('The ID, "%s", is not a state or widget', enteredText) })
					end
				Iris.End()

				if Iris.Tree({ "Widgets" }).isUncollapsed.value then
					local widgetCount = 0
					local widgetStr = ""
					for _, v in lastVDOM do
						widgetCount += 1
						widgetStr ..= "\n" .. v.ID .. " - " .. v.type
					end

					Iris.Text({ "Number of Widgets: " .. widgetCount })

					Iris.Text({ widgetStr })
				end
				Iris.End()
				if Iris.Tree({ "States" }).isUncollapsed.value then
					local stateCount = 0
					local stateStr = ""
					for i, v in states do
						stateCount += 1
						stateStr ..= "\n" .. i .. " - " .. tostring(v.value)
					end

					Iris.Text({ "Number of States: " .. stateCount })

					Iris.Text({ stateStr })
				end
				Iris.End()
			Iris.End()
		end

		local function recursiveMenu()
			-- stylua: ignore start
			if Iris.Menu({ "Recursive" }).state.isOpened.value then
				Iris.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl })
				Iris.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl })
				Iris.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl })
				Iris.Separator()
				Iris.MenuToggle({ "Autosave" })
				Iris.MenuToggle({ "Checked" })
				Iris.Separator()
				Iris.Menu({ "Options" })
					Iris.MenuItem({ "Red" })
					Iris.MenuItem({ "Yellow" })
					Iris.MenuItem({ "Green" })
					Iris.MenuItem({ "Blue" })
					Iris.Separator()
					recursiveMenu()
				Iris.End()
			end
			Iris.End()
			-- stylua: ignore end
			
		end

		local function mainMenuBar()
			Iris.MenuBar()
				Iris.Menu({ "File" })
					Iris.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl })
					Iris.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl })
					Iris.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl })
					recursiveMenu()
					Iris.MenuItem({ "Quit", Enum.KeyCode.Q, Enum.ModifierKey.Alt })
				Iris.End()
				
				Iris.Menu({ "Examples" })
					Iris.MenuToggle({ "Recursive Window" }, { isChecked = showRecursiveWindow })
					Iris.MenuToggle({ "Windowless" }, { isChecked = showWindowlessDemo })
					Iris.MenuToggle({ "Main Menu Bar" }, { isChecked = showMainMenuBarWindow })
				Iris.End()

				Iris.Menu({ "Tools" })
					Iris.MenuToggle({ "Runtime Info" }, { isChecked = showRuntimeInfo })
					Iris.MenuToggle({ "Style Editor" }, { isChecked = showStyleEditor })
				Iris.End()
			Iris.End()
		end

		local function mainMenuBarExample()
			-- local screenSize = Iris.Internal._rootWidget.Instance.PseudoWindowScreenGui.AbsoluteSize
			-- Iris.Window(
			--     {[Iris.Args.Window.NoBackground] = true, [Iris.Args.Window.NoTitleBar] = true, [Iris.Args.Window.NoMove] = true, [Iris.Args.Window.NoResize] = true},
			--     {size = Iris.State(screenSize), position = Iris.State(Vector2.new(0, 0))}
			-- )
			
			mainMenuBar()

			--Iris.End()
		end

		-- allows users to edit state
		local styleEditor
		do
			styleEditor = function()
				local selectedPanel = Iris.State(1)

				local styleList = {
					{
						"Sizing",
						function()
							local UpdatedConfig = Iris.State({})

							if Iris.Button({ "Update Config" }).clicked() then
								Iris.UpdateGlobalConfig(UpdatedConfig:get())
								UpdatedConfig:set({})
							end

							local function SliderInput(input: string, arguments: {any})
								local Input = Iris[input](arguments, { number = Iris.WeakState(Iris._config[arguments[1]]) })
								if Input.numberChanged() then
									UpdatedConfig:get()[arguments[1]] = Input.number:get()
								end
							end

							local function BooleanInput(arguments: {any})
								local Input = Iris.Checkbox(arguments, { isChecked = Iris.WeakState(Iris._config[arguments[1]]) })
								if Input.checked() or Input.unchecked() then
									UpdatedConfig:get()[arguments[1]] = Input.isChecked:get()
								end
							end

							Iris.SeparatorText({ "Main" })
							SliderInput("SliderVector2", {"WindowPadding", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"WindowResizePadding", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"FramePadding", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"ItemSpacing", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"ItemInnerSpacing", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"CellPadding", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderNum", { "IndentSpacing", 1, 0, 36 })
							SliderInput("SliderNum", { "ScrollbarSize", 1, 0, 20 })
							SliderInput("SliderNum", { "GrabMinSize", 1, 0, 20 })

							Iris.SeparatorText{ "Borders & Rounding" }
							SliderInput("SliderNum", { "FrameBorderSize", 0.1, 0, 1 })
							SliderInput("SliderNum", { "WindowBorderSize", 0.1, 0, 1 })
							SliderInput("SliderNum", { "PopupBorderSize", 0.1, 0, 1 })
							SliderInput("SliderNum", { "SeparatorTextBorderSize", 1, 0, 20 })
							SliderInput("SliderNum", { "FrameRounding", 1, 0, 12 })
							SliderInput("SliderNum", { "GrabRounding", 1, 0, 12 })
							SliderInput("SliderNum", { "PopupRounding", 1, 0, 12 })

							Iris.SeparatorText{ "Widgets" }
							SliderInput("SliderVector2", {"DisplaySafeAreaPadding", nil, Vector2.zero, Vector2.one * 20 })
							SliderInput("SliderVector2", {"SeparatorTextPadding", nil, Vector2.zero, Vector2.one * 36 })
							SliderInput("SliderUDim", { "ItemWidth", nil,  UDim.new(), UDim.new(1, 200) })
							SliderInput("SliderUDim", { "ContentWidth", nil, UDim.new(), UDim.new(1, 200) })
							SliderInput("SliderNum", { "TextSize", 1, 4, 20 })
							local TitleInput = Iris.ComboEnum({ "WindowTitleAlign" }, { index = Iris.WeakState(Iris._config.WindowTitleAlign) }, Enum.LeftRight)
							if TitleInput.closed() then
								UpdatedConfig:get().WindowTitleAlign = TitleInput.index:get()
							end
							BooleanInput({ "RichText" })
							BooleanInput({ "TextWrapped" })

							Iris.SeparatorText{ "Config" }
							BooleanInput({ "UseScreenGUIs" })
							BooleanInput({ "IgnoreGuiInset" })
							SliderInput("DragNum", { "DisplayOrderOffset", 1, 0 })
							SliderInput("DragNum", { "ZIndexOffset", 1, 0 })
							SliderInput("SliderNum", { "MouseDoubleClickTime", 0.1, 0, 5 })
							SliderInput("SliderNum", { "MouseDoubleClickMaxDist", 0.1, 0, 20 })
						end,
					},
					{
						"Colors",
						function()
							local UpdatedConfig = Iris.State({})

							if Iris.Button({ "Update Config" }).clicked() then
								Iris.UpdateGlobalConfig(UpdatedConfig:get())
								UpdatedConfig:set({})
							end
							
							local color3s = { "BorderColor", "BorderActiveColor" }

							for _, vColor in color3s do
								local Input = Iris.InputColor3({ vColor }, { color = Iris.WeakState(Iris._config[vColor]) })
								if Input.numberChanged() then
									Iris.UpdateGlobalConfig({ [vColor] = Input.color:get() })
								end
							end

							local color4s = {
								"Text",
								"TextDisabled",
								"WindowBg",
								"ScrollbarGrab",
								"TitleBg",
								"TitleBgActive",
								"TitleBgCollapsed",
								"MenubarBg",
								"FrameBg",
								"FrameBgHovered",
								"FrameBgActive",
								"Button",
								"ButtonHovered",
								"ButtonActive",
								"SliderGrab",
								"SliderGrabActive",
								"Header",
								"HeaderHovered",
								"HeaderActive",
								"SelectionImageObject",
								"SelectionImageObjectBorder",
								"TableBorderStrong",
								"TableBorderLight",
								"TableRowBg",
								"TableRowBgAlt",
								"NavWindowingHighlight",
								"NavWindowingDimBg",
								"Separator",
								"CheckMark",
							}

							for _, vColor in color4s do
								local Input = Iris.InputColor4({ vColor }, {
									color = Iris.WeakState(Iris._config[vColor .. "Color"]),
									transparency = Iris.WeakState(Iris._config[vColor .. "Transparency"]),
								})
								if Input.numberChanged() then
									UpdatedConfig:get()[vColor .. "Color"] = Input.color:get()
									UpdatedConfig:get()[vColor .. "Transparency"] = Input.transparency:get()
								end
							end
						end,
					},
				}

				local window = Iris.Window({ "Style Editor" }, { isOpened = showStyleEditor })
					Iris.Text({ `Clicked close: {window.closed()}` })
					Iris.Text({ "Customize the look of Iris in realtime." })
					Iris.SameLine()
						if Iris.SmallButton({ "Light Theme" }).clicked() then
							Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorLight)
						end
						if Iris.SmallButton({ "Dark Theme" }).clicked() then
							Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
						end
					Iris.End()

					Iris.SameLine()
						if Iris.SmallButton({ "Classic Size" }).clicked() then
							Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
						end
						if Iris.SmallButton({ "Larger Size" }).clicked() then
							Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear)
						end
					Iris.End()

					if Iris.SmallButton({ "Reset Everything" }).clicked() then
						Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
						Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
					end
					Iris.Separator()

					Iris.SameLine()
						for i, v in ipairs(styleList) do
							Iris.RadioButton({ v[1], i }, { index = selectedPanel })
						end
					Iris.End()

					styleList[selectedPanel:get()][2]()
				Iris.End()
			end
		end

		local function widgetEventInteractivity()
			Iris.CollapsingHeader({ "Widget Event Interactivity" })
			local clickCount = Iris.State(0)
			if Iris.Button({ "Click to increase Number" }).clicked() then
				clickCount:set(clickCount:get() + 1)
			end
			Iris.Text({ "The Number is: " .. clickCount:get() })

			Iris.Separator()

			local showEventText = Iris.State(false)
			local selectedEvent = Iris.State("clicked")
			Iris.SameLine()
			Iris.RadioButton({ "clicked", "clicked" }, { index = selectedEvent })
			Iris.RadioButton({ "rightClicked", "rightClicked" }, { index = selectedEvent })
			Iris.RadioButton({ "doubleClicked", "doubleClicked" }, { index = selectedEvent })
			Iris.RadioButton({ "ctrlClicked", "ctrlClicked" }, { index = selectedEvent })
			Iris.End()
			Iris.SameLine()

			if Iris.Button({ selectedEvent:get() .. " to reveal text" })[selectedEvent:get()]() then
				showEventText:set(not showEventText:get())
			end
			if showEventText:get() then
				Iris.Text({ "Here i am!" })
			end

			Iris.End()

			Iris.Separator()

			local showTextTimer = Iris.State(0)
			Iris.SameLine()
			if Iris.Button({ "Click to show text for 20 frames" }).clicked() then
				showTextTimer:set(20)
			end
			if showTextTimer:get() > 0 then
				Iris.Text({ "Here i am!" })
			end
			Iris.End()
			showTextTimer:set(math.max(0, showTextTimer:get() - 1))
			Iris.Text({ "Text Timer: " .. showTextTimer:get() })

			local checkbox0 = Iris.Checkbox({ "Event-tracked checkbox" })
			Iris.Indent()
			Iris.Text({ "unchecked: " .. tostring(checkbox0.unchecked()) })
			Iris.Text({ "checked: " .. tostring(checkbox0.checked()) })
			Iris.End()
			Iris.SameLine()
			if Iris.Button({ "Hover over me" }).hovered() then
				Iris.Text({ "The button is hovered" })
			end
			Iris.End()
			Iris.End()
		end

		local function widgetStateInteractivity()
			Iris.CollapsingHeader({ "Widget State Interactivity" })
			local checkbox0 = Iris.Checkbox({ "Widget-Generated State" })
			Iris.Text({ `isChecked: {checkbox0.state.isChecked.value}\n` })

			local checkboxState0 = Iris.State(false)
			local checkbox1 = Iris.Checkbox({ "User-Generated State" }, { isChecked = checkboxState0 })
			Iris.Text({ `isChecked: {checkbox1.state.isChecked.value}\n` })

			local checkbox2 = Iris.Checkbox({ "Widget Coupled State" })
			local checkbox3 = Iris.Checkbox({ "Coupled to above Checkbox" }, { isChecked = checkbox2.state.isChecked })
			Iris.Text({ `isChecked: {checkbox3.state.isChecked.value}\n` })

			local checkboxState1 = Iris.State(false)
			local _checkbox4 = Iris.Checkbox({ "Widget and Code Coupled State" }, { isChecked = checkboxState1 })
			local Button0 = Iris.Button({ "Click to toggle above checkbox" })
			if Button0.clicked() then
				checkboxState1:set(not checkboxState1:get())
			end
			Iris.Text({ `isChecked: {checkboxState1.value}\n` })

			local checkboxState2 = Iris.State(true)
			local checkboxState3 = Iris.ComputedState(checkboxState2, function(newValue)
				return not newValue
			end)
			local _checkbox5 = Iris.Checkbox({ "ComputedState (dynamic coupling)" }, { isChecked = checkboxState2 })
			local _checkbox5 = Iris.Checkbox({ "Inverted of above checkbox" }, { isChecked = checkboxState3 })
			Iris.Text({ `isChecked: {checkboxState3.value}\n` })

			Iris.End()
		end

		local function dynamicStyle()
			Iris.CollapsingHeader({ "Dynamic Styles" })
			local colorH = Iris.State(0)
			Iris.SameLine()
			if Iris.Button({ "Change Color" }).clicked() then
				colorH:set(math.random())
			end
			Iris.Text({ "Hue: " .. math.floor(colorH:get() * 255) })
			helpMarker("Using PushConfig with a changing value, this can be done with any config field")
			Iris.End()
			Iris.PushConfig({ TextColor = Color3.fromHSV(colorH:get(), 1, 1) })
			Iris.Text({ "Text with a unique and changable color" })
			Iris.PopConfig()
			Iris.End()
		end

		local function tablesDemo()
			local showTablesTree = Iris.State(false)

			Iris.CollapsingHeader({ "Tables & Columns" }, { isUncollapsed = showTablesTree })
			if showTablesTree.value == false then
				-- optimization to skip code which draws GUI which wont be seen.
				-- its a trade off because when the tree becomes opened widgets will all have to be generated again.
				-- Dear ImGui utilizes the same trick, but its less useful here because the Retained mode Backend
				Iris.End()
			else
				Iris.SameLine()
				Iris.Text({ "Table using NextRow and NextColumn syntax:" })
				helpMarker("calling Iris.NextRow() in the outer loop, and Iris.NextColumn()in the inner loop")
				Iris.End()
				Iris.Table({ 3 })
				for i = 1, 4 do
					Iris.NextRow()
					for i2 = 1, 3 do
						Iris.NextColumn()
						Iris.Text({ `Row: {i}, Column: {i2}` })
					end
				end
				Iris.End()

				Iris.Text({ "" })

				Iris.SameLine()
				Iris.Text({ "Table using NextColumn only syntax:" })
				helpMarker("only calling Iris.NextColumn() in the inner loop, the result is identical")
				Iris.End()

				Iris.Table({ 2 })
				for i = 1, 4 do
					for i2 = 1, 2 do
						Iris.NextColumn()
						Iris.Text({ `Row: {i}, Column: {i2}` })
					end
				end
				Iris.End()

				Iris.Separator()

				local TableRowBg = Iris.State(false)
				local TableBordersOuter = Iris.State(false)
				local TableBordersInner = Iris.State(true)
				local TableUseButtons = Iris.State(true)
				local TableNumRows = Iris.State(3)

				Iris.Text({ "Table with Customizable Arguments" })
				Iris.Table({
					4,
					[Iris.Args.Table.RowBg] = TableRowBg.value,
					[Iris.Args.Table.BordersOuter] = TableBordersOuter.value,
					[Iris.Args.Table.BordersInner] = TableBordersInner.value,
				})
				for i = 1, TableNumRows:get() do
					for i2 = 1, 4 do
						Iris.NextColumn()
						if TableUseButtons.value then
							Iris.Button({ `Month: {i}, Week: {i2}` })
						else
							Iris.Text({ `Month: {i}, Week: {i2}` })
						end
					end
				end
				Iris.End()

				Iris.Checkbox({ "RowBg" }, { isChecked = TableRowBg })
				Iris.Checkbox({ "BordersOuter" }, { isChecked = TableBordersOuter })
				Iris.Checkbox({ "BordersInner" }, { isChecked = TableBordersInner })
				Iris.SameLine()
				Iris.RadioButton({ "Buttons", true }, { index = TableUseButtons })
				Iris.RadioButton({ "Text", false }, { index = TableUseButtons })
				Iris.End()
				Iris.InputNum({
					"Number of rows",
					[Iris.Args.InputNum.Min] = 0,
					[Iris.Args.InputNum.Max] = 100,
					[Iris.Args.InputNum.Format] = "%d",
				}, { number = TableNumRows })

				Iris.End()
			end
		end

		local function layoutDemo()
			Iris.CollapsingHeader({ "Widget Layout" })
			Iris.Tree({ "Content Width" })
			local value = Iris.State(50)
			local index = Iris.State(Enum.Axis.X)

			Iris.Text({ "The Content Width is a size property which determines the width of input fields." })
			Iris.SameLine()
			Iris.Text({ "By default the value is UDim.new(0.65, 0)" })
			helpMarker("This is the default value from Dear ImGui.\nIt is 65% of the window width.")
			Iris.End()
			Iris.Text({ "This works well, but sometimes we know how wide elements are going to be and want to maximise the space." })
			Iris.Text({ "Therefore, we can use Iris.PushConfig() to change the width" })

			Iris.Separator()

			Iris.SameLine()
			Iris.Text({ "Content Width = 150 pixels" })
			helpMarker("UDim.new(0, 150)")
			Iris.End()
			Iris.PushConfig({ ContentWidth = UDim.new(0, 150) })
			Iris.DragNum({ "number", 1, 0, 100 }, { number = value })
			Iris.ComboEnum({ "axis" }, { index = index }, Enum.Axis)
			Iris.PopConfig()

			Iris.SameLine()
			Iris.Text({ "Content Width = 50% window width" })
			helpMarker("UDim.new(0.5, 0)")
			Iris.End()
			Iris.PushConfig({ ContentWidth = UDim.new(0.5, 0) })
			Iris.DragNum({ "number", 1, 0, 100 }, { number = value })
			Iris.ComboEnum({ "axis" }, { index = index }, Enum.Axis)
			Iris.PopConfig()

			Iris.SameLine()
			Iris.Text({ "Content Width = -150 pixels from the right side" })
			helpMarker("UDim.new(1, -150)")
			Iris.End()
			Iris.PushConfig({ ContentWidth = UDim.new(1, -150) })
			Iris.DragNum({ "number", 1, 0, 100 }, { number = value })
			Iris.InputEnum({ "axis" }, { index = index }, Enum.Axis)
			Iris.PopConfig()
			Iris.End()
			Iris.End()
		end

		-- showcases how widgets placed outside of a window are placed inside root
		local function windowlessDemo()
			Iris.PushConfig({ ItemWidth = UDim.new(0, 150) })
			Iris.SameLine()
			Iris.TextWrapped({ "Windowless widgets" })
			helpMarker("Widgets which are placed outside of a window will appear on the top left side of the screen.")
			Iris.End()
			Iris.Button({})
			Iris.Tree({})
			Iris.InputText({})
			Iris.End()
			Iris.PopConfig()
		end

		-- main demo window
		return function()
			local NoTitleBar = Iris.State(false)
			local NoBackground = Iris.State(false)
			local NoCollapse = Iris.State(false)
			local NoClose = Iris.State(true)
			local NoMove = Iris.State(false)
			local NoScrollbar = Iris.State(false)
			local NoResize = Iris.State(false)
			local NoNav = Iris.State(false)
			local NoMenu = Iris.State(false)

			if showMainWindow.value == false then
				Iris.Checkbox({ "Open main window" }, { isChecked = showMainWindow })
				return
			end

			local window: Widget = Iris.Window({
				"Iris Demo Window",
				[Iris.Args.Window.NoTitleBar] = NoTitleBar.value,
				[Iris.Args.Window.NoBackground] = NoBackground.value,
				[Iris.Args.Window.NoCollapse] = NoCollapse.value,
				[Iris.Args.Window.NoClose] = NoClose.value,
				[Iris.Args.Window.NoMove] = NoMove.value,
				[Iris.Args.Window.NoScrollbar] = NoScrollbar.value,
				[Iris.Args.Window.NoResize] = NoResize.value,
				[Iris.Args.Window.NoNav] = NoNav.value,
				[Iris.Args.Window.NoMenu] = NoMenu.value,
			}, { size = Iris.State(Vector2.new(600, 550)), position = Iris.State(Vector2.new(100, 25)), isOpened = showMainWindow })

			if window.state.isUncollapsed.value and window.state.isOpened.value then
				mainMenuBar()

				Iris.Text({ "Iris says hello. (" .. Iris.Internal._version .. ")" })

				Iris.CollapsingHeader({ "Window Options" })
					Iris.Table({ 3, false, false, false })
					Iris.NextColumn()
					Iris.Checkbox({ "NoTitleBar" }, { isChecked = NoTitleBar })
					Iris.NextColumn()
					Iris.Checkbox({ "NoBackground" }, { isChecked = NoBackground })
					Iris.NextColumn()
					Iris.Checkbox({ "NoCollapse" }, { isChecked = NoCollapse })
					Iris.NextColumn()
					Iris.Checkbox({ "NoClose" }, { isChecked = NoClose })
					Iris.NextColumn()
					Iris.Checkbox({ "NoMove" }, { isChecked = NoMove })
					Iris.NextColumn()
					Iris.Checkbox({ "NoScrollbar" }, { isChecked = NoScrollbar })
					Iris.NextColumn()
					Iris.Checkbox({ "NoResize" }, { isChecked = NoResize })
					Iris.NextColumn()
					Iris.Checkbox({ "NoNav" }, { isChecked = NoNav })
					Iris.NextColumn()
					Iris.Checkbox({ "NoMenu" }, { isChecked = NoMenu })
					Iris.End()
				Iris.End()

				-- stylua: ignore end

				widgetEventInteractivity()

				widgetStateInteractivity()
				
				Iris.CollapsingHeader({ "Recursive Tree" })
				recursiveTree()
				Iris.End()
				
				dynamicStyle()
				
				Iris.Separator()
				
				Iris.CollapsingHeader({ "Widgets" })
				for _, name in widgetDemosOrder do
					widgetDemos[name]()
				end
				Iris.End()
				
				
				tablesDemo()
				
				layoutDemo()
			end
			Iris.End()

			if showRecursiveWindow.value then
				recursiveWindow(showRecursiveWindow)
			end
			if showRuntimeInfo.value then
				runtimeInfo()
			end
			if showStyleEditor.value then
				styleEditor()
			end
			if showWindowlessDemo.value then
				windowlessDemo()
			end

			if showMainMenuBarWindow.value then
				mainMenuBarExample()
			end

			return window
		end
	end
end)()
--------------------------------------------------------------------------------------------
-- lib/Internal.lua
local internal = (function()
	return function(Iris: Iris): Internal
		--[=[
			@class Internal
			An internal class within Iris containing all the backend data and functions for Iris to operate.
			It is recommended that you don't generally interact with Internal unless you understand what you are doing.
		]=]
		local Internal = {} :: Internal

		--[[
			---------------------------------
				[SECTION] Properties
			---------------------------------
		]]

		Internal._version = [[ 2.2.0 ]]

		Internal._started = false -- has Iris.connect been called yet
		Internal._shutdown = false
		Internal._cycleTick = 0 -- increments for each call to Cycle, used to determine the relative age and freshness of generated widgets

		-- Refresh
		Internal._globalRefreshRequested = false -- refresh means that all GUI is destroyed and regenerated, usually because a style change was made and needed to be propogated to all UI
		Internal._localRefreshActive = false -- if true, when _Insert is called, the widget called will be regenerated

		-- Widgets & Instances
		Internal._widgets = {}
		Internal._widgetCount = 0 -- only used to compute ZIndex, resets to 0 for every cycle
		Internal._stackIndex = 1 -- Points to the index that IDStack is currently in, when computing cycle
		Internal._rootInstance = nil
		Internal._rootWidget = {
			ID = "R",
			type = "Root",
			Instance = Internal._rootInstance,
			ZIndex = 0,
		}
		Internal._lastWidget = Internal._rootWidget -- widget which was most recently rendered

		-- Config
		Internal._rootConfig = {} -- root style which all widgets derive from
		Internal._config = Internal._rootConfig

		-- ID
		Internal._IDStack = { "R" }
		Internal._usedIDs = {} -- hash of IDs which are already used in a cycle, value is the # of occurances so that getID can assign a unique ID for each occurance
		Internal._pushedId = nil
		Internal._nextWidgetId = nil

		-- State
		Internal._states = {} -- Iris.States

		-- Callback
		Internal._postCycleCallbacks = {}
		Internal._connectedFunctions = {} -- functions which run each Iris cycle, connected by the user
		Internal._connections = {}
		Internal._initFunctions = {}

		-- Error
		Internal._fullErrorTracebacks = game:GetService("RunService"):IsStudio()

		--[=[
			@prop _cycleCoroutine thread
			@within Internal

			The thread which handles all connected functions. Each connection is within a pcall statement which prevents
			Iris from crashing and instead stopping at the error.
		]=]
		Internal._cycleCoroutine = coroutine.create(function()
			while Internal._started do
				for _, callback: () -> string in Internal._connectedFunctions do
					local status: boolean, _error: string = pcall(callback)
					if not status then
						-- any error reserts the _stackIndex for the next frame and yields the error.
						Internal._stackIndex = 1
						coroutine.yield(false, _error)
					end
				end
				-- after all callbacks, we yeild so it only runs once a frame.
				coroutine.yield(true)
			end
		end)

		--[[
			-----------------------
				[SECTION] State
			-----------------------
		]]

		--[=[
			@class State
			This class wraps a value in getters and setters, its main purpose is to allow primatives to be passed as objects.
			Constructors for this class are available in [Iris]

			```lua
			local state = Iris.State(0) -- we initialise the state with a value of 0
			
			-- these are equivalent. Ideally you should use `:get()` and ignore `.value`.
			print(state:get())
			print(state.value)

			state:set(state:get() + 1) -- increments the state by getting the current value and adding 1.

			state:onChange(function(newValue)
				print(`The value of the state is now: {newValue}`)
			end)
			```

			:::caution
			Never call ':set()` on a state when inside the the `:onChange()` callback of the same state. This will cause a continous callback.

			Never chain states together so that each state changes the value of another state in a cyclic nature. This will cause a continous callback.
			:::
		]=]

		local StateClass = {}
		StateClass.__index = StateClass

		--[=[
			@method get
			@within State
			@return any
			
			Returns the states current value.
		]=]
		function StateClass:get(): any -- you can also simply use .value
			return self.value
		end

		--[=[
			@method set
			@within State
			
			Allows the caller to assign the state object a new value, and returns the new value.
		]=]
		function StateClass:set(newValue: any): any
			if newValue == self.value then
				-- no need to update on no change.
				return self.value
			end
			self.value = newValue
			for _, thisWidget: Widget in self.ConnectedWidgets do
				Internal._widgets[thisWidget.type].UpdateState(thisWidget)
			end
			for _, callback in self.ConnectedFunctions do
				callback(newValue)
			end
			return self.value
		end

		--[=[
			@method onChange
			@within State
			
			Allows the caller to connect a callback which is called when the states value is changed.
		]=]
		function StateClass:onChange(callback: (newValue: any) -> ())
			table.insert(self.ConnectedFunctions, callback)
		end

		Internal.StateClass = StateClass

		--[[
			---------------------------
				[SECTION] Functions
			---------------------------
		]]

		--[=[
			@function _cycle
			@within Internal
			
			Called every frame to handle all of the widget management. Any previous frame data is ammended and everything updates.
		]=]
		function Internal._cycle()
			if Iris.Disabled then
				return -- Stops all rendering, effectively freezes the current frame with no interaction.
			end

			Internal._rootWidget.lastCycleTick = Internal._cycleTick
			if Internal._rootInstance == nil or Internal._rootInstance.Parent == nil then
				Iris.ForceRefresh()
			end

			for _, widget: Widget in Internal._lastVDOM do
				if widget.lastCycleTick ~= Internal._cycleTick then
					-- a widget which used to be rendered was not called last frame, so we discard it.
					Internal._DiscardWidget(widget)
				end
			end

			-- represents all widgets created last frame. We keep the _lastVDOM to reuse widgets from the previous frame
			-- rather than creating a new instance every frame.
			setmetatable(Internal._lastVDOM, { __mode = "kv" })
			Internal._lastVDOM = Internal._VDOM
			Internal._VDOM = Internal._generateEmptyVDOM()

			-- anything that wnats to run before the frame.
			task.spawn(function()
				for _, callback: () -> () in Internal._postCycleCallbacks do
					callback()
				end
			end)

			if Internal._globalRefreshRequested then
				-- rerender every widget
				--debug.profilebegin("Iris Refresh")
				Internal._generateSelectionImageObject()
				Internal._globalRefreshRequested = false
				for _, widget: Widget in Internal._lastVDOM do
					Internal._DiscardWidget(widget)
				end
				Internal._generateRootInstance()
				Internal._lastVDOM = Internal._generateEmptyVDOM()
				--debug.profileend()
			end

			-- update counters
			Internal._cycleTick += 1
			Internal._widgetCount = 0
			table.clear(Internal._usedIDs)

			-- if Internal.parentInstance:IsA("GuiBase2d") and math.min(Internal.parentInstance.AbsoluteSize.X, Internal.parentInstance.AbsoluteSize.Y) < 100 then
			--     error("Iris Parent Instance is too small")
			-- end
			local compatibleParent: boolean = (Internal.parentInstance:IsA("GuiBase2d") or Internal.parentInstance:IsA("CoreGui") or Internal.parentInstance:IsA("PluginGui") or Internal.parentInstance:IsA("PlayerGui"))
			if compatibleParent == false then
				error("Iris Parent Instance cant contain GUI")
			end

			-- if we are running in Studio, we want full error tracebacks, so we don't have
			-- any pcall to protect from an error.
			if Internal._fullErrorTracebacks then
				for _, callback: () -> () in Internal._connectedFunctions do
					callback()
				end
			else
				--debug.profilebegin("Iris/Generate")

				-- each frame we check on our thread status.
				local coroutineStatus = coroutine.status(Internal._cycleCoroutine)
				if coroutineStatus == "suspended" then
					-- suspended means it yielded, either because it was a complete success
					-- or it caught an error in the code. We run it again for this frame.
					local _, success, result = coroutine.resume(Internal._cycleCoroutine)
					if success == false then
						-- Connected function code errored
						error(result, 0)
					end
				elseif coroutineStatus == "running" then
					-- still running (probably because of an asynchronous method inside a connection).
					error("Iris cycleCoroutine took to long to yield. Connected functions should not yield.")
				else
					-- should never reach this (nothing you can do).
					error("unrecoverable state")
				end
				--debug.profileend()
			end

			if Internal._stackIndex ~= 1 then
				-- has to be larger than 1 because of the check that it isint below 1 in Iris.End
				Internal._stackIndex = 1
				error("Callback has too few calls to Iris.End()", 0)
			end

			--debug.profileend()
		end

		--[=[
			@ignore
			@function _NoOp
			@within Internal

			A dummy function which does nothing. Used as a placeholder for optional methods in a widget class.
			Used in `Internal.WidgetConstructor`
		]=]
		function Internal._NoOp() end

		--  Widget

		--[=[
			@function WidgetConstructor
			@within Internal
			@param type string -- name used to denote the widget class.
			@param widgetClass WidgetClass -- table of methods for the new widget.

			For each widget, a widget class is created which handles all the operations of a widget. This removes the class nature
			of widgets, and simplifies the available functions which can be applied to any widget. The widgets themselves are
			dumb tables containing all the data but no methods to handle any of the data apart from events.
		]=]
		function Internal.WidgetConstructor(type: string, widgetClass: WidgetClass)
			local Fields: { [string]: { [string]: { string } } } = {
				All = {
					Required = {
						"Generate", -- generates the instance.
						"Discard",
						"Update",

						-- not methods !
						"Args",
						"Events",
						"hasChildren",
						"hasState",
					},
					Optional = {},
				},
				IfState = {
					Required = {
						"GenerateState",
						"UpdateState",
					},
					Optional = {},
				},
				IfChildren = {
					Required = {
						"ChildAdded", -- returns the parent of the child widget.
					},
					Optional = {
						"ChildDiscarded",
					},
				},
			}

			-- we ensure all essential functions and properties are present, otherwise the code will break later.
			-- some functions will only be needed if the widget has children or has state.
			local thisWidget = {} :: WidgetClass
			for _, field: string in Fields.All.Required do
				assert(widgetClass[field] ~= nil, `field {field} is missing from widget {type}, it is required for all widgets`)
				thisWidget[field] = widgetClass[field]
			end

			for _, field: string in Fields.All.Optional do
				if widgetClass[field] == nil then
					-- assign a dummy function which does nothing.
					thisWidget[field] = Internal._NoOp
				else
					thisWidget[field] = widgetClass[field]
				end
			end

			if widgetClass.hasState then
				for _, field: string in Fields.IfState.Required do
					assert(widgetClass[field] ~= nil, `field {field} is missing from widget {type}, it is required for all widgets with state`)
					thisWidget[field] = widgetClass[field]
				end
				for _, field: string in Fields.IfState.Optional do
					if widgetClass[field] == nil then
						thisWidget[field] = Internal._NoOp
					else
						thisWidget[field] = widgetClass[field]
					end
				end
			end

			if widgetClass.hasChildren then
				for _, field: string in Fields.IfChildren.Required do
					assert(widgetClass[field] ~= nil, `field {field} is missing from widget {type}, it is required for all widgets with children`)
					thisWidget[field] = widgetClass[field]
				end
				for _, field: string in Fields.IfChildren.Optional do
					if widgetClass[field] == nil then
						thisWidget[field] = Internal._NoOp
					else
						thisWidget[field] = widgetClass[field]
					end
				end
			end

			-- an internal table of all widgets to the widget class.
			Internal._widgets[type] = thisWidget
			-- allowing access to the index for each widget argument.
			Iris.Args[type] = thisWidget.Args

			local ArgNames: { [number]: string } = {}
			for index: string, argument: number in thisWidget.Args do
				ArgNames[argument] = index
			end
			thisWidget.ArgNames = ArgNames

			for index: string, _ in thisWidget.Events do
				if Iris.Events[index] == nil then
					Iris.Events[index] = function()
						return Internal._EventCall(Internal._lastWidget, index)
					end
				end
			end
		end

		--[=[
			@function _Insert
			@within Internal
			@param widgetType: string -- name of widget class.
			@param arguments WidgetArguments? -- arguments of the widget.
			@param states States? -- states of the widget.
			@return Widget -- the widget.

			Every widget is created through _Insert. An ID is generated based on the line of the calling code and is used to
			find the previous frame widget if it exists. If no widget exists, a new one is created.
		]=]
		function Internal._Insert(widgetType: string, args: WidgetArguments?, states: WidgetStates?): Widget
			local thisWidget: Widget
			local ID: ID = Internal._getID(3)
			--debug.profilebegin(ID)

			-- fetch the widget class which contains all the functions for the widget.
			local thisWidgetClass: WidgetClass = Internal._widgets[widgetType]
			Internal._widgetCount += 1

			if Internal._VDOM[ID] then
				-- widget already created once this frame, so we can append to it.
				return Internal._ContinueWidget(ID, widgetType)
			end

			local arguments: Arguments = {} :: Arguments
			if args ~= nil then
				if type(args) ~= "table" then
					args = { args }
				end

				-- convert the arguments to a key-value dictionary so arguments can be referred to by their name and not index.
				for index: number, argument: Argument in args do
					arguments[thisWidgetClass.ArgNames[index]] = argument
				end
			end
			-- prevents tampering with the arguments which are used to check for changes.
			table.freeze(arguments)

			if Internal._lastVDOM[ID] and widgetType == Internal._lastVDOM[ID].type then
				-- found a matching widget from last frame.
				if Internal._localRefreshActive then
					-- we are redrawing every widget.
					Internal._DiscardWidget(Internal._lastVDOM[ID])
				else
					thisWidget = Internal._lastVDOM[ID]
				end
			end
			if thisWidget == nil then
				-- didnt find a match, generate a new widget.
				thisWidget = Internal._GenNewWidget(widgetType, arguments, states, ID)
			end

			if Internal._deepCompare(thisWidget.providedArguments, arguments) == false then
				-- the widgets arguments have changed, the widget should update to reflect changes.
				-- providedArguments is the frozen table which will not change.
				-- the arguments can be altered internally, which happens for the input widgets.
				thisWidget.arguments = Internal._deepCopy(arguments)
				thisWidget.providedArguments = arguments
				thisWidgetClass.Update(thisWidget)
			end

			thisWidget.lastCycleTick = Internal._cycleTick
			thisWidget.Disabled = Iris._config.DisableWidget

			if thisWidgetClass.hasChildren then
				-- a parent widget, so we increase our depth.
				Internal._stackIndex += 1
				Internal._IDStack[Internal._stackIndex] = thisWidget.ID
			end

			Internal._VDOM[ID] = thisWidget
			Internal._lastWidget = thisWidget

			--debug.profileend()

			return thisWidget
		end

		--[=[
			@function _GenNewWidget
			@within Internal
			@param widgetType string
			@param arguments Arguments -- arguments of the widget.
			@param states States? -- states of the widget.
			@param ID ID -- id of the new widget. Determined in `Internal._Insert`
			@return Widget -- the newly created widget.

			All widgets are created as tables with properties. The widget class contains the functions to create the UI instances and
			update the widget or change state.
		]=]
		function Internal._GenNewWidget(widgetType: string, arguments: Arguments, states: WidgetStates?, ID: ID): Widget
			local parentId: ID = Internal._IDStack[Internal._stackIndex]
			local thisWidgetClass: WidgetClass = Internal._widgets[widgetType]

			-- widgets are just tables with properties.
			local thisWidget = {} :: Widget
			setmetatable(thisWidget, thisWidget)

			thisWidget.ID = ID
			thisWidget.type = widgetType
			thisWidget.parentWidget = Internal._VDOM[parentId]
			thisWidget.trackedEvents = {}

			-- widgets have lots of space to ensure they are always visible.
			thisWidget.ZIndex = thisWidget.parentWidget.ZIndex + (Internal._widgetCount * 0x40) + Internal._config.ZIndexOffset

			thisWidget.Instance = thisWidgetClass.Generate(thisWidget)
			thisWidget.Instance.Parent = if Internal._config.Parent then Internal._config.Parent else Internal._widgets[thisWidget.parentWidget.type].ChildAdded(thisWidget.parentWidget, thisWidget)

			-- we can modify the arguments table, but keep a frozen copy to compare for user-end changes.
			thisWidget.providedArguments = arguments
			thisWidget.arguments = Internal._deepCopy(arguments)
			thisWidgetClass.Update(thisWidget)

			local eventMTParent
			if thisWidgetClass.hasState then
				if states then
					for index: string, state: State in states do
						if not (type(state) == "table" and getmetatable(state :: any) == Internal.StateClass) then
							-- generate a new state.
							states[index] = Internal._widgetState(thisWidget, index, state)
						end
					end

					thisWidget.state = states
					for _, state: State in states do
						state.ConnectedWidgets[thisWidget.ID] = thisWidget
					end
				else
					thisWidget.state = {}
				end

				thisWidgetClass.GenerateState(thisWidget)
				thisWidgetClass.UpdateState(thisWidget)

				-- the state MT can't be itself because state has to explicitly only contain stateClass objects
				thisWidget.stateMT = {}
				setmetatable(thisWidget.state, thisWidget.stateMT)

				thisWidget.__index = thisWidget.state
				eventMTParent = thisWidget.stateMT
			else
				eventMTParent = thisWidget
			end

			eventMTParent.__index = function(_, eventName: string)
				return function()
					return Internal._EventCall(thisWidget, eventName)
				end
			end
			return thisWidget
		end

		--[=[
			@function _ContinueWidget
			@within Internal
			@param ID ID -- id of the widget.
			@param widgetType string
			@return Widget -- the widget.

			Since the widget has already been created this frame, we can just add it back to the stack. There is no checking of
			arguments or states.
			Basically equivalent to the end of `Internal._Insert`.
		]=]
		function Internal._ContinueWidget(ID: ID, widgetType: string): Widget
			local thisWidgetClass: WidgetClass = Internal._widgets[widgetType]
			local thisWidget: Widget = Internal._VDOM[ID]

			if thisWidgetClass.hasChildren then
				-- a parent widget so we increase our depth.
				Internal._stackIndex += 1
				Internal._IDStack[Internal._stackIndex] = thisWidget.ID
			end

			Internal._lastWidget = thisWidget
			return thisWidget
		end

		--[=[
			@function _DiscardWidget
			@within Internal
			@param widgetToDiscard Widget

			Destroys the widget instance and updates any parent. This happens if the widget was not called in the
			previous frame. There is no code which needs to update any widget tables since they are already reset
			at the start before discarding happens.
		]=]
		function Internal._DiscardWidget(widgetToDiscard: Widget)
			local widgetParent = widgetToDiscard.parentWidget
			if widgetParent then
				-- if the parent needs to update it's children.
				Internal._widgets[widgetParent.type].ChildDiscarded(widgetParent, widgetToDiscard)
			end

			-- using the widget class discard function.
			Internal._widgets[widgetToDiscard.type].Discard(widgetToDiscard)
		end

		--[=[
			@function _widgetState
			@within Internal
			@param thisWidget Widget -- widget the state belongs to.
			@param stateName string
			@param initialValue any
			@return State -- the state for the widget.

			Connects the state to the widget. If no state exists then a new one is created. Called for every state in every
			widget if the user does not provide a state.
		]=]
		function Internal._widgetState(thisWidget: Widget, stateName: string, initialValue: any): State
			local ID: ID = thisWidget.ID .. stateName
			if Internal._states[ID] then
				Internal._states[ID].ConnectedWidgets[thisWidget.ID] = thisWidget
				return Internal._states[ID]
			else
				Internal._states[ID] = {
					value = initialValue,
					ConnectedWidgets = { [thisWidget.ID] = thisWidget },
					ConnectedFunctions = {},
				}
				setmetatable(Internal._states[ID], Internal.StateClass)
				return Internal._states[ID]
			end
		end

		--[=[
			@function _EventCall
			@within Internal
			@param thisWidget Widget
			@param evetName string
			@return boolean -- the value of the event.

			A wrapper for any event on any widget. Automatically, Iris does not initialize events unless they are explicitly
			called so in the first frame, the event connections are set up. Every event is a function which returns a boolean.
		]=]
		function Internal._EventCall(thisWidget: Widget, eventName: string): boolean
			local Events: Events = Internal._widgets[thisWidget.type].Events
			local Event: Event = Events[eventName]
			assert(Event ~= nil, `widget {thisWidget.type} has no event of name {eventName}`)

			if thisWidget.trackedEvents[eventName] == nil then
				Event.Init(thisWidget)
				thisWidget.trackedEvents[eventName] = true
			end
			return Event.Get(thisWidget)
		end

		--[=[
			@function _GetParentWidget
			@within Internal
			@return Widget -- the parent widget

			Returns the parent widget of the currently active widget, based on the stack depth.
		]=]
		function Internal._GetParentWidget(): Widget
			return Internal._VDOM[Internal._IDStack[Internal._stackIndex]]
		end

		-- Generate

		--[=[
			@ignore
			@function _generateEmptyVDOM
			@within Internal

			Creates the VDOM at the start of each frame containing jsut the root instance.
		]=]
		function Internal._generateEmptyVDOM(): { [ID]: Widget }
			return {
				["R"] = Internal._rootWidget,
			}
		end

		--[=[
			@ignore
			@function _generateRootInstance
			@within Internal

			Creates the root instance.
		]=]
		function Internal._generateRootInstance()
			-- unsafe to call before Internal.connect
			Internal._rootInstance = Internal._widgets["Root"].Generate(Internal._widgets["Root"])
			Internal._rootInstance.Parent = Internal.parentInstance
			Internal._rootWidget.Instance = Internal._rootInstance
		end

		--[=[
			@ignore
			@function _generateSelctionImageObject
			@within Internal

			Creates the selection object for buttons.
		]=]
		function Internal._generateSelectionImageObject()
			if Internal.SelectionImageObject then
				Internal.SelectionImageObject:Destroy()
			end

			local SelectionImageObject: Frame = Instance.new("Frame")
			SelectionImageObject.Position = UDim2.fromOffset(-1, -1)
			SelectionImageObject.Size = UDim2.new(1, 2, 1, 2)
			SelectionImageObject.BackgroundColor3 = Internal._config.SelectionImageObjectColor
			SelectionImageObject.BackgroundTransparency = Internal._config.SelectionImageObjectTransparency
			SelectionImageObject.BorderSizePixel = 0

			local UIStroke: UIStroke = Instance.new("UIStroke")
			UIStroke.Thickness = 1
			UIStroke.Color = Internal._config.SelectionImageObjectBorderColor
			UIStroke.Transparency = Internal._config.SelectionImageObjectBorderTransparency
			UIStroke.LineJoinMode = Enum.LineJoinMode.Round
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			UIStroke.Parent = SelectionImageObject

			local Rounding: UICorner = Instance.new("UICorner")
			Rounding.CornerRadius = UDim.new(0, 2)

			Rounding.Parent = SelectionImageObject

			Internal.SelectionImageObject = SelectionImageObject
		end

		-- Utility

		--[=[
			@function _getID
			@within Internal
			@param levelsToIgnore number -- used to skip over internal calls to `_getID`.

			Generates a unique ID for each widget which is based on the line that the widget is
			created from. This ensures that the function is heuristic and always returns the same
			id for the same widget.
		]=]
		function Internal._getID(levelsToIgnore: number): ID
			if Internal._nextWidgetId then
				local ID: ID = Internal._nextWidgetId
				Internal._nextWidgetId = nil
				return ID
			end

			local i: number = 1 + (levelsToIgnore or 1)
			local ID: ID = ""
			local levelInfo: number = debug.info(i, "l")
			while levelInfo ~= -1 and levelInfo ~= nil do
				ID ..= "+" .. levelInfo
				i += 1
				levelInfo = debug.info(i, "l")
			end

			if Internal._usedIDs[ID] then
				Internal._usedIDs[ID] += 1
			else
				Internal._usedIDs[ID] = 1
			end

			local discriminator = if Internal._pushedId then Internal._pushedId else Internal._usedIDs[ID]

			return ID .. ":" .. discriminator
		end

		--[=[
			@ignore
			@function _deepCompare
			@within Internal
			@param t1 table
			@param t2 table

			Compares two tables to check if they are the same. It uses a recursive iteration through one table
			to compare against the other. Used to determine if the arguments of a widget have changed since last
			frame.
		]=]
		function Internal._deepCompare(t1: {}, t2: {}): boolean
			-- unoptimized ?
			for i, v1 in t1 do
				local v2 = t2[i]
				if type(v1) == "table" then
					if v2 and type(v2) == "table" then
						if Internal._deepCompare(v1, v2) == false then
							return false
						end
					else
						return false
					end
				else
					if type(v1) ~= type(v2) or v1 ~= v2 then
						return false
					end
				end
			end

			return true
		end

		--[=[
			@ignore
			@function _deepCopy
			@within Internal
			@param t table

			Performs a deep copy of a table so that neither table contains a shared reference.
		]=]
		function Internal._deepCopy(t: {}): {}
			local copy: {} = {}

			for k: any, v: any in pairs(t) do
				if type(v) == "table" then
					v = Internal._deepCopy(v)
				end
				copy[k] = v
			end

			return copy
		end

		-- VDOM
		Internal._lastVDOM = Internal._generateEmptyVDOM()
		Internal._VDOM = Internal._generateEmptyVDOM()

		Iris.Internal = Internal
		Iris._config = Internal._config
		return Internal
	end
end)()
--------------------------------------------------------------------------------------------
-- lib/API.lua
local api = (function()
	return function(Iris: Iris)
		-- basic wrapper for nearly every widget, saves space.
		local function wrapper(name: string): (arguments: WidgetArguments?, states: WidgetStates?) -> Widget
			return function(arguments: WidgetArguments?, states: WidgetStates?): Widget
				return Iris.Internal._Insert(name, arguments, states)
			end
		end
	
		--[[
			----------------------------
				[SECTION] Window API
			----------------------------
		]]
		--[=[
			@class Window
			
			Windows are the fundamental widget for Iris. Every other widget must be a descendant of a window.
	
			```lua
			Iris.Window({ "Example Window" })
				Iris.Text({ "This is an example window!" })
			Iris.End()
			```
	
			If you do not want the code inside a window to run unless it is open then you can use the following:
			```lua
			local window = Iris.Window({ "Many Widgets Window" })
	
			if window.state.isOpened.value and window.state.isUncollapsed.value then
				Iris.Text({ "I will only be created when the window is open." })
			end
			Iris.End() -- must always call Iris.End(), regardless of whether the window is open or not.
			```
		]=]
	
		--[=[
			@prop Window Iris.Window
			@within Window
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			The top-level container for all other widgets to be created within.
			Can be moved and resized across the screen. Cannot contain embedded windows.
			Menus can be appended to windows creating a menubar.
			
			```lua
			hasChildren = true
			hasState = true
			Arguments = {
				Title: string,
				NoTitleBar: boolean? = false,
				NoBackground: boolean? = false, -- the background behind the widget container.
				NoCollapse: boolean? = false,
				NoClose: boolean? = false,
				NoMove: boolean? = false,
				NoScrollbar: boolean? = false, -- the scrollbar if the window is too short for all widgets.
				NoResize: boolean? = false,
				NoNav: boolean? = false, -- unimplemented.
				NoMenu: boolean? -- whether the menubar will show if created.
			}
			Events = {
				opened: () -> boolean, -- once when opened.
				closed: () -> boolean, -- once when closed.
				collapsed: () -> boolean, -- once when collapsed.
				uncollapsed: () -> boolean, -- once when uncollapsed.
				hovered: () -> boolean -- fires when the mouse hovers over any of the window.
			}
			States = {
				size = State<Vector2>?,
				position = State<Vector2>?,
				isUncollapsed = State<boolean>?,
				isOpened = State<boolean>?,
				scrollDistance = State<number>? -- vertical scroll distance, if too short.
			}
			```
		]=]
		Iris.Window = wrapper("Window")
	
		--[=[
			@function SetFocusedWindow
			@within Iris
			@param window Widget -- the window to focus.
	
			Sets the focused window to the window provided, which brings it to the front and makes it active.
		]=]
		Iris.SetFocusedWindow = Iris.Internal.SetFocusedWindow
	
		--[=[
			@prop Tooltip Iris.Tooltip
			@within Window
			@tag Widget
	
			Displays a text label next to the cursor
			
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string
			}
			```
		]=]
		Iris.Tooltip = wrapper("Tooltip")
	
		--[[
			---------------------------------
				[SECTION] Menu Widget API
			---------------------------------
		]]
		--[=[
			@class Menu
			Menu API
		]=]
	
		--[=[
			@prop MenuBar Iris.MenuBar
			@within Menu
			@tag Widget
			@tag HasChildren
			
			Creates a MenuBar for the current window. Must be called directly under a Window and not within a child widget.
			:::info
				This does not create any menus, just tells the window that we going to add menus within.
			:::
			
			```lua
			hasChildren = true
			hasState = false
			```
		]=]
		Iris.MenuBar = wrapper("MenuBar")
	
		--[=[
			@prop Menu Iris.Menu
			@within Menu
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			Creates an collapsable menu. If the Menu is created directly under a MenuBar, then the widget will
			be placed horizontally below the window title. If the menu Menu is created within another menu, then
			it will be placed vertically alongside MenuItems and display an arrow alongside.
	
			The opened menu will be a vertically listed box below or next to the button.
	
			:::info
			There are widgets which are designed for being parented to a menu whilst other happens to work. There is nothing
			preventing you from adding any widget as a child, but the behaviour is unexplained and not intended, despite allowed.
			:::
			
			```lua
			hasChildren = true
			hasState = true
			Arguments = {
				Text: string -- menu text.
			}
			Events = {
				clicked: () -> boolean,
				opened: () -> boolean, -- once when opened.
				closed: () -> boolean, -- once when closed.
				hovered: () -> boolean
			}
			States = {
				isOpened: State<boolean>? -- whether the menu is open, including any sub-menus within.
			}
			```
		]=]
		Iris.Menu = wrapper("Menu")
	
		--[=[
			@prop MenuItem Iris.MenuItem
			@within Menu
			@tag Widget
			
			Creates a button within a menu. The optional KeyCode and ModiferKey arguments will show the keys next
			to the title, but **will not** bind any connection to them. You will need to do this yourself.
			
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
				KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
				ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
			}
			Events = {
				clicked: () -> boolean,
				hovered: () -> boolean
			}
			```
		]=]
		Iris.MenuItem = wrapper("MenuItem")
	
		--[=[
			@prop MenuToggle Iris.MenuToggle
			@within Menu
			@tag Widget
			@tag HasState
			
			Creates a togglable button within a menu. The optional KeyCode and ModiferKey arguments act the same
			as the MenuItem. It is not visually the same as a checkbox, but has the same functionality.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string,
				KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
				ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
			}
			Events = {
				checked: () -> boolean, -- once on check.
				unchecked: () -> boolean, -- once on uncheck.
				hovered: () -> boolean
			}
			States = {
				isChecked: State<boolean>?
			}
			```
		]=]
		Iris.MenuToggle = wrapper("MenuToggle")
	
		--[[
			-----------------------------------
				[SECTION] Format Widget Iris
			-----------------------------------
		]]
		--[=[
			@class Format
			Format API
		]=]
	
		--[=[
			@prop Separator Iris.Separator
			@within Format
			@tag Widget
	
			A vertical or horizonal line, depending on the context, which visually seperates widgets.
			
			```lua
			hasChildren = false
			hasState = false
			```
		]=]
		Iris.Separator = wrapper("Separator")
	
		--[=[
			@prop Indent Iris.Indent
			@within Format
			@tag Widget
			@tag HasChildren
			
			Indents its child widgets.
			
			```lua
			hasChildren = true
			hasState = false
			Arguments = {
				Width: number? = Iris._config.IndentSpacing -- indent width ammount.
			}
			```
		]=]
		Iris.Indent = wrapper("Indent")
	
		--[=[
			@prop Sameline Iris.Sameline
			@within Format
			@tag Widget
			@tag HasChildren
			
			Positions its children in a row, horizontally.
			
			```lua
			hasChildren = true
			hasState = false
			Arguments = {
				Width: number? = Iris._config.ItemSpacing.X, -- horizontal spacing between child widgets.
				VerticalAlignment: Enum.VerticalAlignment? = Enum.VerticalAlignment.Center -- how widgets are aligned to the widget.
			}
			```
		]=]
		Iris.SameLine = wrapper("SameLine")
	
		--[=[
			@prop Group Iris.Group
			@within Format
			@tag Widget
			@tag HasChildren
			
			Layout widget which contains its children as a single group.
			
			```lua
			hasChildren = true
			hasState = false
			```
		]=]
		Iris.Group = wrapper("Group")
	
		--[[
			---------------------------------
				[SECTION] Text Widget API
			---------------------------------
		]]
		--[=[
			@class Text
			Text Widget API
		]=]
	
		--[=[
			@prop Text Iris.Text
			@within Text
			@tag Widget
			
			A text label to display the text argument.
			The Wrapped argument will make the text wrap around if it is cut off by its parent.
			The Color argument will change the color of the text, by default it is defined in the configuration file.
			The RichText argument will 
	
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
				Wrapped: boolean? = [CONFIG] = false, -- whether the text will wrap around inside the parent container. If not specified, then equal to the config
				Color: Color3? = Iris._config.TextColor, -- the colour of the text.
				RichText: boolean? = [CONFIG] = false -- enable RichText. If not specified, then equal to the config
			}
			Events = {
				hovered: () -> boolean
			}
			```
		]=]
		Iris.Text = wrapper("Text")
	
		--[=[
			@prop TextWrapped Iris.Text
			@within Text
			@tag Widget
			@deprecated v2.0.0 -- Use 'Text' with the Wrapped argument or change the config.
	
			An alias for [Iris.Text](Text#Text) with the Wrapped argument set to true, and the text will wrap around if cut off by its parent.
	
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
			}
			Events = {
				hovered: () -> boolean
			}
			```
		]=]
		Iris.TextWrapped = function(arguments: WidgetArguments): Widget
			arguments[2] = true
			return Iris.Internal._Insert("Text", arguments)
		end
	
		--[=[
			@prop TextColored Iris.Text
			@within Text
			@tag Widget
			@deprecated v2.0.0 -- Use 'Text' with the Color argument or change the config.
			
			An alias for [Iris.Text](Text#Text) with the color set by the Color argument.
	
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
				Color: Color3 -- the colour of the text.
			}
			Events = {
				hovered: () -> boolean
			}
			```
		]=]
		Iris.TextColored = function(arguments: WidgetArguments): Widget
			arguments[3] = arguments[2]
			arguments[2] = nil
			return Iris.Internal._Insert("Text", arguments)
		end
	
		--[=[
			@prop SeparatorText Iris.SeparatorText
			@within Text
			@tag Widget
			
			Similar to [Iris.Separator](Format#Separator) but with a text label to be used as a header
			when an [Iris.Tree](Tree#Tree) or [Iris.CollapsingHeader](Tree#CollapsingHeader) is not appropriate.
	
			Visually a full width thin line with a text label clipping out part of the line.
			
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string
			}
			```
		]=]
		Iris.SeparatorText = wrapper("SeparatorText")
	
		--[=[
			@prop InputText Iris.InputText
			@within Text
			@tag Widget
			@tag HasState
	
			A field which allows the user to enter text.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputText",
				TextHint: string? = "" -- a hint to display when the text box is empty.
			}
			Events = {
				textChanged: () -> boolean, -- whenever the textbox looses focus and a change was made.
				hovered: () -> boolean
			}
			States = {
				text: State<string>?
			}
			```
		]=]
		Iris.InputText = wrapper("InputText")
	
		--[[
			----------------------------------
				[SECTION] Basic Widget API
			----------------------------------
		]]
		--[=[
			@class Basic
			Basic Widget API
		]=]
	
		--[=[
			@prop Button Iris.Button
			@within Basic
			@tag Widget
			
			A clickable button the size of the text with padding. Can listen to the `clicked()` event to determine if it was pressed.
	
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
			}
			Events = {
				clicked: () -> boolean,
				rightClicked: () -> boolean,
				doubleClicked: () -> boolean,
				ctrlClicked: () -> boolean, -- when the control key is down and clicked.
				hovered: () -> boolean
			}
			```
		]=]
		Iris.Button = wrapper("Button")
	
		--[=[
			@prop SmallButton Iris.SmallButton
			@within Basic
			@tag Widget
			
			A smaller clickable button, the same as a [Iris.Button](Basic#Button) but without padding. Can listen to the `clicked()` event to determine if it was pressed.
	
			```lua
			hasChildren = false
			hasState = false
			Arguments = {
				Text: string,
			}
			Events = {
				clicked: () -> boolean,
				rightClicked: () -> boolean,
				doubleClicked: () -> boolean,
				ctrlClicked: () -> boolean, -- when the control key is down and clicked.
				hovered: () -> boolean
			}
			```
		]=]
		Iris.SmallButton = wrapper("SmallButton")
	
		--[=[
			@prop Checkbox Iris.Checkbox
			@within Basic
			@tag Widget
			@tag HasState
			
			A checkable box with a visual tick to represent a boolean true or false state.
	
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string
			}
			Events = {
				checked: () -> boolean, -- once when checked.
				unchecked: () -> boolean, -- once when unchecked.
				hovered: () -> boolean
			}
			State = {
				isChecked = State<boolean>? -- whether the box is checked.
			}
			```
		]=]
		Iris.Checkbox = wrapper("Checkbox")
	
		--[=[
			@prop RadioButton Iris.RadioButton
			@within Basic
			@tag Widget
			@tag HasState
			
			A circular selectable button, changing the state to its index argument. Used in conjunction with multiple other RadioButtons sharing the same state to represent one value from multiple options.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string,
				Index: any -- the state object is set to when clicked.
			}
			Events = {
				selected: () -> boolean,
				unselected: () -> boolean,
				active: () -> boolean, -- if the state index equals the RadioButton's index.
				hovered: () -> boolean
			}
			State = {
				index = State<any>? -- the state set by the index of a RadioButton.
			}
			```
		]=]
		Iris.RadioButton = wrapper("RadioButton")
	
		--[[
			---------------------------------
				[SECTION] Tree Widget API
			---------------------------------
		]]
		--[=[
			@class Tree
			Tree Widget API
		]=]
	
		--[=[
			@prop Tree Iris.Tree
			@within Tree
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			A collapsable container for other widgets, to organise and hide widgets when not needed. The state determines whether the child widgets are visible or not. Clicking on the widget will collapse or uncollapse it.
			
			```lua
			hasChildren: true
			hasState: true
			Arguments = {
				Text: string,
				SpanAvailWidth: boolean? = false, -- the tree title will fill all horizontal space to the end its parent container.
				NoIndent: boolean? = false -- the child widgets will not be indented underneath.
			}
			Events = {
				collapsed: () -> boolean,
				uncollapsed: () -> boolean,
				hovered: () -> boolean
			}
			State = {
				isUncollapsed: State<boolean>? -- whether the widget is collapsed.
			}
			```
		]=]
		Iris.Tree = wrapper("Tree")
	
		--[=[
			@prop CollapsingHeader Iris.CollapsingHeader
			@within Tree
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			The same as a Tree Widget, but with a larger title and clearer, used mainly for organsing widgets on the first level of a window.
			
			```lua
			hasChildren: true
			hasState: true
			Arguments = {
				Text: string
			}
			Events = {
				collapsed: () -> boolean,
				uncollapsed: () -> boolean,
				hovered: () -> boolean
			}
			State = {
				isUncollapsed: State<boolean>? -- whether the widget is collapsed.
			}
			```
		]=]
		Iris.CollapsingHeader = wrapper("CollapsingHeader")
	
		--[[
			----------------------------------
				[SECTION] Input Widget API
			----------------------------------
		]]
		--[=[
			@class Input
			Input Widget API
	
			Input Widgets are textboxes for typing in specific number values. See [Drag], [Slider] or [InputText](Text#InputText) for more input 
	
			Iris provides a set of specific inputs for the datatypes:
			Number,
			[Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2),
			[Vector3](https://create.roblox.com/docs/reference/engine/datatypes/Vector3),
			[UDim](https://create.roblox.com/docs/reference/engine/datatypes/UDim),
			[UDim2](https://create.roblox.com/docs/reference/engine/datatypes/UDim2),
			[Rect](https://create.roblox.com/docs/reference/engine/datatypes/Rect),
			[Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3)
			and the custom [Color4](https://create.roblox.com/docs/reference/engine/datatypes/Color3).
			
			Each Input widget has the same arguments but the types depend of the DataType:
			1. Text: string? = "Input{type}" -- the text to be displayed to the right of the textbox.
			2. Increment: DataType? = nil, -- the increment argument determines how a value will be rounded once the textbox looses focus.
			3. Min: DataType? = nil, -- the minimum value that the widget will allow, no clamping by default.
			4. Max: DataType? = nil, -- the maximum value that the widget will allow, no clamping by default.
			5. Format: string | { string }? = [DYNAMIC] -- uses `string.format` to customise visual display.
	
			The format string can either by a single value which will apply to every box, or a table allowing specific text.
	
			:::note
			If you do not specify a format option then Iris will dynamically calculate a relevant number of sigifs and format option.
			For example, if you have Increment, Min and Max values of 1, 0 and 100, then Iris will guess that you are only using integers
			and will format the value as an integer.
			As another example, if you have Increment, Min and max values of 0.005, 0, 1, then Iris will guess you are using a float of 3
			significant figures.
	
			Additionally, for certain DataTypes, Iris will append an prefix to each box if no format option is provided.
			For example, a Vector3 box will have the append values of "X: ", "Y: " and "Z: " to the relevant input box.
			:::
		]=]
	
		--[=[
			@prop InputNum Iris.InputNum
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for numbers. The number can be either an integer or a float.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputNum",
				Increment: number? = nil,
				Min: number? = nil,
				Max: number? = nil,
				Format: string? | { string }? = [DYNAMIC], -- Iris will dynamically generate an approriate format.
				NoButtons: boolean? = false -- whether to display + and - buttons next to the input box.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<number>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputNum = wrapper("InputNum")
	
		--[=[
			@prop InputVector2 Iris.InputVector2
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for Vector2. The numbers can be either integers or floats.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputVector2",
				Increment: Vector2? = nil,
				Min: Vector2? = nil,
				Max: Vector2? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputVector2 = wrapper("InputVector2")
	
		--[=[
			@prop InputVector3 Iris.InputVector3
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for Vector3. The numbers can be either integers or floats.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputVector3",
				Increment: Vector3? = nil,
				Min: Vector3? = nil,
				Max: Vector3? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector3>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputVector3 = wrapper("InputVector3")
	
		--[=[
			@prop InputUDim Iris.InputUDim
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for UDim. The Scale box will be a float and the Offset box will be
			an integer, unless specified differently.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputUDim",
				Increment: UDim? = nil,
				Min: UDim? = nil,
				Max: UDim? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputUDim = wrapper("InputUDim")
	
		--[=[
			@prop InputUDim2 Iris.InputUDim2
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for UDim2. The Scale boxes will be floats and the Offset boxes will be
			integers, unless specified differently.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputUDim2",
				Increment: UDim2? = nil,
				Min: UDim2? = nil,
				Max: UDim2? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputUDim2 = wrapper("InputUDim2")
	
		--[=[
			@prop InputRect Iris.InputRect
			@within Input
			@tag Widget
			@tag HasState
			
			An input box for Rect. The numbers will default to integers, unless specified differently.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputRect",
				Increment: Rect? = nil,
				Min: Rect? = nil,
				Max: Rect? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Rect>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputRect = wrapper("InputRect")
	
		--[[
			---------------------------------
				[SECTION] Drag Widget API
			---------------------------------
		]]
		--[=[
			@class Drag
			Drag Widget API
	
			A draggable widget for each datatype. Allows direct typing input but also dragging values by clicking and holding.
			
			See [Input] for more details on the arguments.
		]=]
	
		--[=[
			@prop DragNum Iris.DragNum
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a number.
			You can ctrl + click to directly input a number, like InputNum.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragNum",
				Increment: number? = nil,
				Min: number? = nil,
				Max: number? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<number>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragNum = wrapper("DragNum")
	
		--[=[
			@prop DragVector2 Iris.DragVector2
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a Vector2.
			You can ctrl + click to directly input a Vector2, like InputVector2.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragVector2",
				Increment: Vector2? = nil,
				Min: Vector2? = nil,
				Max: Vector2? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragVector2 = wrapper("DragVector2")
	
		--[=[
			@prop DragVector3 Iris.DragVector3
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a Vector3.
			You can ctrl + click to directly input a Vector3, like InputVector3.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragVector3",
				Increment: Vector3? = nil,
				Min: Vector3? = nil,
				Max: Vector3? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector3>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragVector3 = wrapper("DragVector3")
	
		--[=[
			@prop DragUDim Iris.DragUDim
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a UDim.
			You can ctrl + click to directly input a UDim, like InputUDim.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragUDim",
				Increment: UDim? = nil,
				Min: UDim? = nil,
				Max: UDim? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragUDim = wrapper("DragUDim")
	
		--[=[
			@prop DragUDim2 Iris.DragUDim2
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a UDim2.
			You can ctrl + click to directly input a UDim2, like InputUDim2.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragUDim2",
				Increment: UDim2? = nil,
				Min: UDim2? = nil,
				Max: UDim2? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragUDim2 = wrapper("DragUDim2")
	
		--[=[
			@prop DragRect Iris.DragRect
			@within Drag
			@tag Widget
			@tag HasState
			
			A field which allows the user to click and drag their cursor to enter a Rect.
			You can ctrl + click to directly input a Rect, like InputRect.
			You can hold Shift to increase speed, and Alt to decrease speed when dragging.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "DragRect",
				Increment: Rect? = nil,
				Min: Rect? = nil,
				Max: Rect? = nil,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Rect>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.DragRect = wrapper("DragRect")
	
		--[=[
			@prop InputColor3 Iris.InputColor3
			@within Drag
			@tag Widget
			@tag HasState
			
			An input box for Color3. The input boxes are draggable between 0 and 255 or if UseFloats then between 0 and 1.
			Input can also be done using HSV instead of the default RGB.
			If no format argument is provided then a default R, G, B or H, S, V prefix is applied.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputColor3",
				UseFloats: boolean? = false, -- constrain the values between floats 0 and 1 or integers 0 and 255.
				UseHSV: boolean? = false, -- input using HSV instead.
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				color: State<Color3>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputColor3 = wrapper("InputColor3")
	
		--[=[
			@prop InputColor4 Iris.InputColor4
			@within Drag
			@tag Widget
			@tag HasState
			
			An input box for Color4. Color4 is a combination of Color3 and a fourth transparency argument.
			It has two states for this purpose.
			The input boxes are draggable between 0 and 255 or if UseFloats then between 0 and 1.
			Input can also be done using HSV instead of the default RGB.
			If no format argument is provided then a default R, G, B, T or H, S, V, T prefix is applied.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "InputColor4",
				UseFloats: boolean? = false, -- constrain the values between floats 0 and 1 or integers 0 and 255.
				UseHSV: boolean? = false, -- input using HSV instead.
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				color: State<Color3>?,
				transparency: State<number>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.InputColor4 = wrapper("InputColor4")
	
		--[[
			-----------------------------------
				[SECTION] Slider Widget API
			-----------------------------------
		]]
		--[=[
			@class Slider
			Slider Widget API
	
			A draggable widget with a visual bar constrained between a min and max for each datatype.
			Allows direct typing input but also dragging the slider by clicking and holding anywhere in the box.
			
			See [Input] for more details on the arguments.
		]=]
	
		--[=[
			@prop SliderNum Iris.SliderNum
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a number within a range.
			You can ctrl + click to directly input a number, like InputNum.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderNum",
				Increment: number? = 1,
				Min: number? = 0,
				Max: number? = 100,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<number>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderNum = wrapper("SliderNum")
	
		--[=[
			@prop SliderVector2 Iris.SliderVector2
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a Vector2 within a range.
			You can ctrl + click to directly input a Vector2, like InputVector2.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderVector2",
				Increment: Vector2? = { 1, 1 },
				Min: Vector2? = { 0, 0 },
				Max: Vector2? = { 100, 100 },
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderVector2 = wrapper("SliderVector2")
	
		--[=[
			@prop SliderVector3 Iris.SliderVector3
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a Vector3 within a range.
			You can ctrl + click to directly input a Vector3, like InputVector3.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderVector3",
				Increment: Vector3? = { 1, 1, 1 },
				Min: Vector3? = { 0, 0, 0 },
				Max: Vector3? = { 100, 100, 100 },
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Vector3>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderVector3 = wrapper("SliderVector3")
	
		--[=[
			@prop SliderUDim Iris.SliderUDim
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a UDim within a range.
			You can ctrl + click to directly input a UDim, like InputUDim.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderUDim",
				Increment: UDim? = { 0.01, 1 },
				Min: UDim? = { 0, 0 },
				Max: UDim? = { 1, 960 },
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderUDim = wrapper("SliderUDim")
	
		--[=[
			@prop SliderUDim2 Iris.SliderUDim2
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a UDim2 within a range.
			You can ctrl + click to directly input a UDim2, like InputUDim2.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderUDim2",
				Increment: UDim2? = { 0.01, 1, 0.01, 1 },
				Min: UDim2? = { 0, 0, 0, 0 },
				Max: UDim2? = { 1, 960, 1, 960 },
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<UDim2>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderUDim2 = wrapper("SliderUDim2")
	
		--[=[
			@prop SliderRect Iris.SliderRect
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a Rect within a range.
			You can ctrl + click to directly input a Rect, like InputRect.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderRect",
				Increment: Rect? = { 1, 1, 1, 1 },
				Min: Rect? = { 0, 0, 0, 0 },
				Max: Rect? = { 960, 960, 960, 960 },
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<Rect>?,
				editingText: State<boolean>?
			}
			```
		]=]
		Iris.SliderRect = wrapper("SliderRect")
	
		--[=[
			@private
			@prop SliderNum Iris.SliderNum
			@within Slider
			@tag Widget
			@tag HasState
			
			A field which allows the user to slide a grip to enter a number within a range.
			You can ctrl + click to directly input a number, like InputNum.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "SliderNum",
				Increment: number? = 1,
				Min: number? = 0,
				Max: number? = 100,
				Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
			}
			Events = {
				numberChanged: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				number: State<number>?,
				editingText: State<boolean>?
			}
			```
		]=]
		-- Iris.SliderEnum = wrapper("SliderEnum")
	
		--[[
			----------------------------------
				[SECTION] Combo Widget API
			----------------------------------
		]]
		--[=[
			@class Combo
			Combo Widget API
		]=]
	
		--[=[
			@prop Selectable Iris.Selectable
			@within Combo
			@tag Widget
			@tag HasState
			
			An object which can be selected.
			
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string,
				Index: any, -- index of selectable value.
				NoClick: boolean? = false -- prevents the selectable from being clicked by the user.
			}
			Events = {
				selected: () -> boolean,
				unselected: () -> boolean,
				active: () -> boolean,
				clicked: () -> boolean,
				rightClicked: () -> boolean,
				doubleClicked: () -> boolean,
				ctrlClicked: () -> boolean,
				hovered: () -> boolean,
			}
			States = {
				index: State<any> -- a shared state between all selectables.
			}
			```
		]=]
		Iris.Selectable = wrapper("Selectable")
	
		--[=[
			@prop Combo Iris.Combo
			@within Combo
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			A selection box to choose a value from a range of values.
			
			```lua
			hasChildren = true
			hasState = true
			Arguments = {
				Text: string,
				NoButton: boolean? = false, -- hide the dropdown button.
				NoPreview: boolean? = false -- hide the preview field.
			}
			Events = {
				opened: () -> boolean,
				clsoed: () -> boolean,
				clicked: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				index: State<any>,
				isOpened: State<boolean>?
			}
			```
		]=]
		Iris.Combo = wrapper("Combo")
	
		--[=[
			@prop ComboArray Iris.Combo
			@within Combo
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			A selection box to choose a value from an array.
			
			```lua
			hasChildren = true
			hasState = true
			Arguments = {
				Text: string,
				NoButton: boolean? = false, -- hide the dropdown button.
				NoPreview: boolean? = false -- hide the preview field.
			}
			Events = {
				opened: () -> boolean,
				clsoed: () -> boolean,
				clicked: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				index: State<any>,
				isOpened: State<boolean>?
			}
			Extra = {
				selectionArray: { any } -- the array to generate a combo from.
			}
			```
		]=]
		Iris.ComboArray = function(arguments: WidgetArguments, states: WidgetStates?, selectionArray: { any })
			local defaultState
			if states == nil then
				defaultState = Iris.State(selectionArray[1])
			else
				defaultState = states
			end
			local thisWidget = Iris.Internal._Insert("Combo", arguments, defaultState)
			local sharedIndex: State = thisWidget.state.index
			for _, Selection in selectionArray do
				Iris.Internal._Insert("Selectable", { Selection, Selection }, { index = sharedIndex } :: States)
			end
			Iris.End()
	
			return thisWidget
		end
	
		--[=[
			@prop ComboEnum Iris.Combo
			@within Combo
			@tag Widget
			@tag HasChildren
			@tag HasState
			
			A selection box to choose a value from an Enum.
			
			```lua
			hasChildren = true
			hasState = true
			Arguments = {
				Text: string,
				NoButton: boolean? = false, -- hide the dropdown button.
				NoPreview: boolean? = false -- hide the preview field.
			}
			Events = {
				opened: () -> boolean,
				clsoed: () -> boolean,
				clicked: () -> boolean,
				hovered: () -> boolean
			}
			States = {
				index: State<any>,
				isOpened: State<boolean>?
			}
			Extra = {
				enumType: Enum -- the enum to generate a combo from.
			}
			```
		]=]
		Iris.ComboEnum = function(arguments: WidgetArguments, states: WidgetStates?, enumType: Enum)
			local defaultState
			if states == nil then
				defaultState = Iris.State(enumType[1])
			else
				defaultState = states
			end
			local thisWidget = Iris.Internal._Insert("Combo", arguments, defaultState)
			local sharedIndex = thisWidget.state.index
			for _, Selection in enumType:GetEnumItems() do
				Iris.Internal._Insert("Selectable", { Selection.Name, Selection }, { index = sharedIndex } :: States)
			end
			Iris.End()
	
			return thisWidget
		end
		Iris.InputEnum = Iris.ComboEnum
	
		--[[
			---------------------------------
				[SECTION] Plot Widget API
			---------------------------------
		]]
		--[=[
			@class Plot
			Plot Widget API
		]=]
	
		--[=[
			@prop ProgressBar Iris.PrograssBar
			@within Plot
			@tag Widget
			@tag HasState
	
			A progress bar line with a state value to show the current state.
	
			```lua
			hasChildren = false
			hasState = true
			Arguments = {
				Text: string? = "Progress Bar",
				Format: string? = nil -- optional to override with a custom progress such as `29/54`
			}
			Events = {
				hovered: () -> boolean,
				changed: () -> boolean
			}
			States = {
				progress: State<number>?
			}
			```
		]=]
		Iris.ProgressBar = wrapper("ProgressBar")
	
		--[[
			----------------------------------
				[SECTION] Table Widget API
			----------------------------------
		]]
		--[=[
			@class Table
			Table Widget API
		]=]
	
		--[=[
			@prop Table Iris.Table
			@within Table
			@tag Widget
			@tag HasChildren
			
			A layout widget which allows children to be displayed in configurable columns and rows.
			
			```lua
			hasChildren = true
			hasState = false
			Arguments = {
				NumColumns = number,
				RowBg = boolean? = false, -- whether the row backgrounds alternate a background fill.
				BordersOuter = boolean? = false,
				BordersInner = boolean? = false, -- borders on each cell.
			}
			Events = {
				hovered: () -> boolean
			}
			```
		]=]
		Iris.Table = wrapper("Table")
	
		--[=[
			@function NextColumn
			@within Table
			
			In a table, moves to the next available cell. if the current cell is in the last column,
			then the next cell will be the first column of the next row.
		]=]
		Iris.NextColumn = function()
			Iris.Internal._GetParentWidget().RowColumnIndex += 1
		end
	
		--[=[
			@function SetColumnIndex
			@within Table
			@param index number
			
			In a table, directly sets the index of the column.
		]=]
		Iris.SetColumnIndex = function(columnIndex: number)
			local ParentWidget: Widget = Iris.Internal._GetParentWidget()
			assert(columnIndex >= ParentWidget.InitialNumColumns, "Iris.SetColumnIndex Argument must be in column range")
			ParentWidget.RowColumnIndex = math.floor(ParentWidget.RowColumnIndex / ParentWidget.InitialNumColumns) + (columnIndex - 1)
		end
	
		--[=[
			@function NextRow
			@within Table
			
			In a table, moves to the next available row,
			skipping cells in the previous column if the last cell wasn't in the last column
		]=]
		Iris.NextRow = function()
			-- sets column Index back to 0, increments Row
			local ParentWidget: Widget = Iris.Internal._GetParentWidget()
			local InitialNumColumns: number = ParentWidget.InitialNumColumns
			local nextRow: number = math.floor((ParentWidget.RowColumnIndex + 1) / InitialNumColumns) * InitialNumColumns
			ParentWidget.RowColumnIndex = nextRow
		end
	end
end)()
--------------------------------------------------------------------------------------------
-- lib/widgets/init.lua
local widgets = (function()
	local widgets = {} :: WidgetUtility

	return function(Iris: Internal)
		widgets.GuiService = game:GetService("GuiService")
		widgets.RunService = game:GetService("RunService")
		widgets.UserInputService = game:GetService("UserInputService")
		widgets.ContextActionService = game:GetService("ContextActionService")
		widgets.TextService = game:GetService("TextService")

		widgets.ICONS = {
			RIGHT_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_right.png",
			DOWN_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_down.png",
			MULTIPLICATION_SIGN = "rbxasset://textures/AnimationEditor/icon_close.png", -- best approximation for a close X which roblox supports, needs to be scaled about 2x
			BOTTOM_RIGHT_CORNER = "\u{25E2}", -- used in window resize icon in bottom right
			CHECK_MARK = "rbxasset://textures/AnimationEditor/icon_checkmark.png",
			ALPHA_BACKGROUND_TEXTURE = "rbxasset://textures/meshPartFallback.png", -- used for color4 alpha
		}

		widgets.GuiInset = widgets.GuiService:GetGuiInset()

		widgets.IS_STUDIO = widgets.RunService:IsStudio()
		function widgets.getTime()
			-- time() always returns 0 in the context of plugins
			if widgets.IS_STUDIO then
				return os.clock()
			else
				return time()
			end
		end

		function widgets.getMouseLocation(): Vector2
			return widgets.UserInputService:GetMouseLocation() - widgets.GuiInset
		end

		function widgets.findBestWindowPosForPopup(refPos: Vector2, size: Vector2, outerMin: Vector2, outerMax: Vector2): Vector2
			local CURSOR_OFFSET_DIST: number = 20

			if refPos.X + size.X + CURSOR_OFFSET_DIST > outerMax.X then
				if refPos.Y + size.Y + CURSOR_OFFSET_DIST > outerMax.Y then
					-- placed to the top
					refPos += Vector2.new(0, -(CURSOR_OFFSET_DIST + size.Y))
				else
					-- placed to the bottom
					refPos += Vector2.new(0, CURSOR_OFFSET_DIST)
				end
			else
				-- placed to the right
				refPos += Vector2.new(CURSOR_OFFSET_DIST, 0)
			end

			local clampedPos: Vector2 = Vector2.new(math.max(math.min(refPos.X + size.X, outerMax.X) - size.X, outerMin.X), math.max(math.min(refPos.Y + size.Y, outerMax.Y) - size.Y, outerMin.Y))
			return clampedPos
		end

		function widgets.isPosInsideRect(pos: Vector2, rectMin: Vector2, rectMax: Vector2): boolean
			return pos.X > rectMin.X and pos.X < rectMax.X and pos.Y > rectMin.Y and pos.Y < rectMax.Y
		end

		function widgets.extend(superClass: WidgetClass, subClass: WidgetClass): WidgetClass
			local newClass: WidgetClass = table.clone(superClass)
			for index: string, value: any in subClass do
				newClass[index] = value
			end
			return newClass
		end

		function widgets.UIPadding(Parent: GuiObject, PxPadding: Vector2): UIPadding
			local UIPaddingInstance: UIPadding = Instance.new("UIPadding")
			UIPaddingInstance.PaddingLeft = UDim.new(0, PxPadding.X)
			UIPaddingInstance.PaddingRight = UDim.new(0, PxPadding.X)
			UIPaddingInstance.PaddingTop = UDim.new(0, PxPadding.Y)
			UIPaddingInstance.PaddingBottom = UDim.new(0, PxPadding.Y)
			UIPaddingInstance.Parent = Parent
			return UIPaddingInstance
		end

		function widgets.UIListLayout(Parent: GuiObject, FillDirection: Enum.FillDirection, Padding: UDim): UIListLayout
			local UIListLayoutInstance: UIListLayout = Instance.new("UIListLayout")
			UIListLayoutInstance.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayoutInstance.Padding = Padding
			UIListLayoutInstance.FillDirection = FillDirection
			UIListLayoutInstance.Parent = Parent
			return UIListLayoutInstance
		end

		function widgets.UIStroke(Parent: GuiObject, Thickness: number, Color: Color3, Transparency: number): UIStroke
			local UIStrokeInstance: UIStroke = Instance.new("UIStroke")
			UIStrokeInstance.Thickness = Thickness
			UIStrokeInstance.Color = Color
			UIStrokeInstance.Transparency = Transparency
			UIStrokeInstance.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStrokeInstance.LineJoinMode = Enum.LineJoinMode.Round
			UIStrokeInstance.Parent = Parent
			return UIStrokeInstance
		end

		function widgets.UICorner(Parent: GuiObject, PxRounding: number?): UICorner
			local UICornerInstance: UICorner = Instance.new("UICorner")
			UICornerInstance.CornerRadius = UDim.new(PxRounding and 0 or 1, PxRounding or 0)
			UICornerInstance.Parent = Parent
			return UICornerInstance
		end

		function widgets.UISizeConstraint(Parent: GuiObject, MinSize: Vector2?, MaxSize: Vector2?): UISizeConstraint
			local UISizeConstraintInstance: UISizeConstraint = Instance.new("UISizeConstraint")
			UISizeConstraintInstance.MinSize = MinSize or UISizeConstraintInstance.MinSize -- made these optional
			UISizeConstraintInstance.MaxSize = MaxSize or UISizeConstraintInstance.MaxSize
			UISizeConstraintInstance.Parent = Parent
			return UISizeConstraintInstance
		end

		function widgets.UIReference(Parent: GuiObject, Child: GuiObject, Name: string): ObjectValue
			local ObjectValue: ObjectValue = Instance.new("ObjectValue")
			ObjectValue.Name = Name
			ObjectValue.Value = Child
			ObjectValue.Parent = Parent

			return ObjectValue
		end

		function widgets.getScreenSizeForWindow(thisWidget: Widget): Vector2 -- possible parents are GuiBase2d, CoreGui, PlayerGui
			local size: Vector2
			if thisWidget.Instance:IsA("GuiBase2d") then
				size = thisWidget.Instance.AbsoluteSize
			else
				local rootParent = thisWidget.Instance.Parent
				if rootParent:IsA("GuiBase2d") then
					size = rootParent.AbsoluteSize
				else
					if rootParent.Parent:IsA("GuiBase2d") then
						size = rootParent.AbsoluteSize
					else
						size = workspace.CurrentCamera.ViewportSize
					end
				end
			end
			return size
		end

		-- below uses Iris

		local textParams: GetTextBoundsParams = Instance.new("GetTextBoundsParams")
		textParams.Font = Iris._config.TextFont
		textParams.Size = Iris._config.TextSize
		textParams.Width = math.huge
		function widgets.calculateTextSize(text: string, width: number?): Vector2
			if width then
				textParams.Width = width
			end
			textParams.Text = text

			local size: Vector2 = widgets.TextService:GetTextBoundsAsync(textParams)

			if width then
				textParams.Width = math.huge
			end

			return size
		end

		function widgets.applyTextStyle(thisInstance: TextLabel & TextButton & TextBox)
			thisInstance.FontFace = Iris._config.TextFont
			thisInstance.TextSize = Iris._config.TextSize
			thisInstance.TextColor3 = Iris._config.TextColor
			thisInstance.TextTransparency = Iris._config.TextTransparency
			thisInstance.TextXAlignment = Enum.TextXAlignment.Left
			thisInstance.RichText = Iris._config.RichText
			thisInstance.TextWrapped = Iris._config.TextWrapped

			thisInstance.AutoLocalize = false
		end

		function widgets.applyInteractionHighlights(thisWidget: Widget, Button: GuiButton, Highlightee: GuiObject, Colors: { [string]: any })
			local exitedButton: boolean = false
			widgets.applyMouseEnter(thisWidget, Button, function()
				Highlightee.BackgroundColor3 = Colors.ButtonHoveredColor
				Highlightee.BackgroundTransparency = Colors.ButtonHoveredTransparency

				exitedButton = false
			end)

			widgets.applyMouseLeave(thisWidget, Button, function()
				Highlightee.BackgroundColor3 = Colors.ButtonColor
				Highlightee.BackgroundTransparency = Colors.ButtonTransparency

				exitedButton = true
			end)

			widgets.applyInputBegan(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
					return
				end
				Highlightee.BackgroundColor3 = Colors.ButtonActiveColor
				Highlightee.BackgroundTransparency = Colors.ButtonActiveTransparency
			end)

			widgets.applyInputEnded(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
					return
				end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Highlightee.BackgroundColor3 = Colors.ButtonHoveredColor
					Highlightee.BackgroundTransparency = Colors.ButtonHoveredTransparency
				end
				if input.UserInputType == Enum.UserInputType.Gamepad1 then
					Highlightee.BackgroundColor3 = Colors.ButtonColor
					Highlightee.BackgroundTransparency = Colors.ButtonTransparency
				end
			end)

			Button.SelectionImageObject = Iris.SelectionImageObject
		end

		function widgets.applyInteractionHighlightsWithMultiHighlightee(thisWidget: Widget, Button: GuiButton, Highlightees: { { GuiObject | { [string]: Color3 | number } } })
			local exitedButton: boolean = false
			widgets.applyMouseEnter(thisWidget, Button, function()
				for _, Highlightee in Highlightees do
					Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonHoveredColor
					Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonHoveredTransparency

					exitedButton = false
				end
			end)

			widgets.applyMouseLeave(thisWidget, Button, function()
				for _, Highlightee in Highlightees do
					Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonColor
					Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonTransparency

					exitedButton = true
				end
			end)

			widgets.applyInputBegan(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
					return
				end
				for _, Highlightee in Highlightees do
					Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonActiveColor
					Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonActiveTransparency
				end
			end)

			widgets.applyInputEnded(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
					return
				end
				for _, Highlightee in Highlightees do
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonHoveredColor
						Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonHoveredTransparency
					end
					if input.UserInputType == Enum.UserInputType.Gamepad1 then
						Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonColor
						Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonTransparency
					end
				end
			end)

			Button.SelectionImageObject = Iris.SelectionImageObject
		end

		function widgets.applyTextInteractionHighlights(thisWidget: Widget, Button: GuiButton, Highlightee: TextLabel & TextButton & TextBox, Colors: { [string]: any })
			local exitedButton = false
			widgets.applyMouseEnter(thisWidget, Button, function()
				Highlightee.TextColor3 = Colors.ButtonHoveredColor
				Highlightee.TextTransparency = Colors.ButtonHoveredTransparency

				exitedButton = false
			end)

			widgets.applyMouseLeave(thisWidget, Button, function()
				Highlightee.TextColor3 = Colors.ButtonColor
				Highlightee.TextTransparency = Colors.ButtonTransparency

				exitedButton = true
			end)

			widgets.applyInputBegan(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
					return
				end
				Highlightee.TextColor3 = Colors.ButtonActiveColor
				Highlightee.TextTransparency = Colors.ButtonActiveTransparency
			end)

			widgets.applyInputEnded(thisWidget, Button, function(input: InputObject)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
					return
				end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Highlightee.TextColor3 = Colors.ButtonHoveredColor
					Highlightee.TextTransparency = Colors.ButtonHoveredTransparency
				end
				if input.UserInputType == Enum.UserInputType.Gamepad1 then
					Highlightee.TextColor3 = Colors.ButtonColor
					Highlightee.TextTransparency = Colors.ButtonTransparency
				end
			end)

			Button.SelectionImageObject = Iris.SelectionImageObject
		end

		function widgets.applyFrameStyle(thisInstance: GuiObject, forceNoPadding: boolean?, doubleyNoPadding: boolean?)
			-- padding, border, and rounding
			-- optimized to only use what instances are needed, based on style
			local FramePadding: Vector2 = Iris._config.FramePadding
			local FrameBorderSize: number = Iris._config.FrameBorderSize
			local FrameBorderColor: Color3 = Iris._config.BorderColor
			local FrameBorderTransparency: number = Iris._config.ButtonTransparency
			local FrameRounding: number = Iris._config.FrameRounding

			if FrameBorderSize > 0 and FrameRounding > 0 then
				thisInstance.BorderSizePixel = 0

				local uiStroke: UIStroke = Instance.new("UIStroke")
				uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				uiStroke.LineJoinMode = Enum.LineJoinMode.Round
				uiStroke.Transparency = FrameBorderTransparency
				uiStroke.Thickness = FrameBorderSize
				uiStroke.Color = FrameBorderColor

				widgets.UICorner(thisInstance, FrameRounding)
				uiStroke.Parent = thisInstance

				if not forceNoPadding then
					widgets.UIPadding(thisInstance, Iris._config.FramePadding)
				end
			elseif FrameBorderSize < 1 and FrameRounding > 0 then
				thisInstance.BorderSizePixel = 0

				widgets.UICorner(thisInstance, FrameRounding)
				if not forceNoPadding then
					widgets.UIPadding(thisInstance, Iris._config.FramePadding)
				end
			elseif FrameRounding < 1 then
				thisInstance.BorderSizePixel = FrameBorderSize
				thisInstance.BorderColor3 = FrameBorderColor
				thisInstance.BorderMode = Enum.BorderMode.Inset

				if not forceNoPadding then
					widgets.UIPadding(thisInstance, FramePadding - Vector2.new(FrameBorderSize, FrameBorderSize))
				elseif not doubleyNoPadding then
					widgets.UIPadding(thisInstance, -Vector2.new(FrameBorderSize, FrameBorderSize))
				end
			end
		end

		function widgets.applyButtonClick(thisWidget: Widget, thisInstance: GuiButton, callback: () -> ())
			thisInstance.MouseButton1Click:Connect(function()
				if thisWidget.Disabled then
					return
				end
				callback()
			end)
		end

		function widgets.applyButtonDown(thisWidget: Widget, thisInstance: GuiButton, callback: (x: number, y: number) -> ())
			thisInstance.MouseButton1Down:Connect(function(...)
				if thisWidget.Disabled then
					return
				end
				callback(...)
			end)
		end

		function widgets.applyMouseEnter(thisWidget: Widget, thisInstance: GuiObject, callback: () -> ())
			thisInstance.MouseEnter:Connect(function(...)
				if thisWidget.Disabled then
					return
				end
				callback()
			end)
		end

		function widgets.applyMouseLeave(thisWidget: Widget, thisInstance: GuiObject, callback: () -> ())
			thisInstance.MouseLeave:Connect(function(...)
				if thisWidget.Disabled then
					return
				end
				callback()
			end)
		end

		function widgets.applyInputBegan(thisWidget: Widget, thisInstance: GuiButton, callback: (input: InputObject) -> ())
			thisInstance.InputBegan:Connect(function(...)
				if thisWidget.Disabled then
					return
				end
				callback(...)
			end)
		end

		function widgets.applyInputEnded(thisWidget: Widget, thisInstance: GuiButton, callback: (input: InputObject) -> ())
			thisInstance.InputEnded:Connect(function(...)
				if thisWidget.Disabled then
					return
				end
				callback(...)
			end)
		end

		function widgets.discardState(thisWidget: Widget)
			for _, state: State in thisWidget.state do
				state.ConnectedWidgets[thisWidget.ID] = nil
			end
		end

		function widgets.registerEvent(event: string, callback: (...any) -> ())
			table.insert(Iris._initFunctions, function()
				table.insert(Iris._connections, widgets.UserInputService[event]:Connect(callback))
			end)
		end

		widgets.EVENTS = {
			hover = function(pathToHovered: (thisWidget: Widget) -> GuiObject)
				return {
					["Init"] = function(thisWidget: Widget)
						local hoveredGuiObject: GuiObject = pathToHovered(thisWidget)
						widgets.applyMouseEnter(thisWidget, hoveredGuiObject, function()
							thisWidget.isHoveredEvent = true
						end)
						widgets.applyMouseLeave(thisWidget, hoveredGuiObject, function()
							thisWidget.isHoveredEvent = false
						end)
						thisWidget.isHoveredEvent = false
					end,
					["Get"] = function(thisWidget: Widget): boolean
						return thisWidget.isHoveredEvent
					end,
				}
			end,

			click = function(pathToClicked: (thisWidget: Widget) -> GuiButton)
				return {
					["Init"] = function(thisWidget: Widget)
						local clickedGuiObject: GuiButton = pathToClicked(thisWidget)
						thisWidget.lastClickedTick = -1

						widgets.applyButtonClick(thisWidget, clickedGuiObject, function()
							thisWidget.lastClickedTick = Iris._cycleTick + 1
						end)
					end,
					["Get"] = function(thisWidget: Widget): boolean
						return thisWidget.lastClickedTick == Iris._cycleTick
					end,
				}
			end,

			rightClick = function(pathToClicked: (thisWidget: Widget) -> GuiButton)
				return {
					["Init"] = function(thisWidget: Widget)
						local clickedGuiObject: GuiButton = pathToClicked(thisWidget)
						thisWidget.lastRightClickedTick = -1

						clickedGuiObject.MouseButton2Click:Connect(function()
							if thisWidget.Disabled then
								return
							end
							thisWidget.lastRightClickedTick = Iris._cycleTick + 1
						end)
					end,
					["Get"] = function(thisWidget: Widget): boolean
						return thisWidget.lastRightClickedTick == Iris._cycleTick
					end,
				}
			end,

			doubleClick = function(pathToClicked: (thisWidget: Widget) -> GuiButton)
				return {
					["Init"] = function(thisWidget: Widget)
						local clickedGuiObject: GuiButton = pathToClicked(thisWidget)
						thisWidget.lastClickedTime = -1
						thisWidget.lastClickedPosition = Vector2.zero
						thisWidget.lastDoubleClickedTick = -1

						widgets.applyButtonDown(thisWidget, clickedGuiObject, function(x: number, y: number)
							local currentTime: number = widgets.getTime()
							local isTimeValid: boolean = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
							if isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist then
								thisWidget.lastDoubleClickedTick = Iris._cycleTick + 1
							else
								thisWidget.lastClickedTime = currentTime
								thisWidget.lastClickedPosition = Vector2.new(x, y)
							end
						end)
					end,
					["Get"] = function(thisWidget: Widget): boolean
						return thisWidget.lastDoubleClickedTick == Iris._cycleTick
					end,
				}
			end,

			ctrlClick = function(pathToClicked: (thisWidget: Widget) -> GuiButton)
				return {
					["Init"] = function(thisWidget: Widget)
						local clickedGuiObject: GuiButton = pathToClicked(thisWidget)
						thisWidget.lastCtrlClickedTick = -1

						widgets.applyButtonClick(thisWidget, clickedGuiObject, function()
							if widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
								thisWidget.lastCtrlClickedTick = Iris._cycleTick + 1
							end
						end)
					end,
					["Get"] = function(thisWidget: Widget): boolean
						return thisWidget.lastCtrlClickedTick == Iris._cycleTick
					end,
				}
			end,
		}

		Iris._utility = widgets
		local root = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local NumNonWindowChildren: number = 0

				--stylua: ignore
				Iris.WidgetConstructor("Root", {
					hasState = false,
					hasChildren = true,
					Args = {},
					Events = {},
					Generate = function(_thisWidget: Widget)
						local Root: Folder = Instance.new("Folder")
						Root.Name = "Iris_Root"

						local PseudoWindowScreenGui
						if Iris._config.UseScreenGUIs then
							PseudoWindowScreenGui = Instance.new("ScreenGui")
							PseudoWindowScreenGui.ResetOnSpawn = false
							PseudoWindowScreenGui.DisplayOrder = Iris._config.DisplayOrderOffset
							PseudoWindowScreenGui.IgnoreGuiInset = Iris._config.IgnoreGuiInset
						else
							PseudoWindowScreenGui = Instance.new("Frame")
							PseudoWindowScreenGui.AnchorPoint = Vector2.new(0.5, 0.5)
							PseudoWindowScreenGui.Position = UDim2.new(0.5, 0, 0.5, 0)
							PseudoWindowScreenGui.Size = UDim2.new(1, 0, 1, 0)
							PseudoWindowScreenGui.BackgroundTransparency = 1
							PseudoWindowScreenGui.ZIndex = Iris._config.DisplayOrderOffset
						end
						PseudoWindowScreenGui.Name = "PseudoWindowScreenGui"
						PseudoWindowScreenGui.Parent = Root

						local PopupScreenGui
						if Iris._config.UseScreenGUIs then
							PopupScreenGui = Instance.new("ScreenGui")
							PopupScreenGui.ResetOnSpawn = false
							PopupScreenGui.DisplayOrder = Iris._config.DisplayOrderOffset + 1024 -- room for 1024 regular windows before overlap
							PopupScreenGui.IgnoreGuiInset = Iris._config.IgnoreGuiInset
						else
							PopupScreenGui = Instance.new("Frame")
							PopupScreenGui.AnchorPoint = Vector2.new(0.5, 0.5)
							PopupScreenGui.Position = UDim2.new(0.5, 0, 0.5, 0)
							PopupScreenGui.Size = UDim2.new(1, 0, 1, 0)
							PopupScreenGui.BackgroundTransparency = 1
							PopupScreenGui.ZIndex = Iris._config.DisplayOrderOffset + 1024
						end
						PopupScreenGui.Name = "PopupScreenGui"
						PopupScreenGui.Parent = Root

						local TooltipContainer: Frame = Instance.new("Frame")
						TooltipContainer.Name = "TooltipContainer"
						TooltipContainer.AutomaticSize = Enum.AutomaticSize.XY
						TooltipContainer.Size = UDim2.fromOffset(0, 0)
						TooltipContainer.BackgroundTransparency = 1
						TooltipContainer.BorderSizePixel = 0

						widgets.UIListLayout(TooltipContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.PopupBorderSize))

						TooltipContainer.Parent = PopupScreenGui

						local MenuBarContainer: Frame = Instance.new("Frame")
						MenuBarContainer.Name = "MenuBarContainer"
						MenuBarContainer.AutomaticSize = Enum.AutomaticSize.Y
						MenuBarContainer.Size = UDim2.fromScale(1, 0)
						MenuBarContainer.BackgroundTransparency = 1
						MenuBarContainer.BorderSizePixel = 0

						MenuBarContainer.Parent = PopupScreenGui

						local PseudoWindow: Frame = Instance.new("Frame")
						PseudoWindow.Name = "PseudoWindow"
						PseudoWindow.Size = UDim2.new(0, 0, 0, 0)
						PseudoWindow.Position = UDim2.fromOffset(0, 22)
						PseudoWindow.AutomaticSize = Enum.AutomaticSize.XY
						PseudoWindow.BackgroundTransparency = Iris._config.WindowBgTransparency
						PseudoWindow.BackgroundColor3 = Iris._config.WindowBgColor
						PseudoWindow.BorderSizePixel = Iris._config.WindowBorderSize
						PseudoWindow.BorderColor3 = Iris._config.BorderColor

						PseudoWindow.Selectable = false
						PseudoWindow.SelectionGroup = true
						PseudoWindow.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
						PseudoWindow.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
						PseudoWindow.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
						PseudoWindow.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

						PseudoWindow.Visible = false

						widgets.UIPadding(PseudoWindow, Iris._config.WindowPadding)
						widgets.UIListLayout(PseudoWindow, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

						PseudoWindow.Parent = PseudoWindowScreenGui

						return Root
					end,
					Update = function(thisWidget: Widget)
						if NumNonWindowChildren > 0 then
							local Root = thisWidget.Instance :: any
							local PseudoWindowScreenGui = Root.PseudoWindowScreenGui :: any
							local PseudoWindow: Frame = PseudoWindowScreenGui.PseudoWindow
							PseudoWindow.Visible = true
						end
					end,
					Discard = function(thisWidget: Widget)
						NumNonWindowChildren = 0
						thisWidget.Instance:Destroy()
					end,
					ChildAdded = function(thisWidget: Widget, childWidget: Widget)
						local Root = thisWidget.Instance :: any

						if childWidget.type == "Window" then
							return thisWidget.Instance
						elseif childWidget.type == "Tooltip" then
							return Root.PopupScreenGui.TooltipContainer
						elseif childWidget.type == "MenuBar" then
							return Root.PopupScreenGui.MenuBarContainer
						else
							local PseudoWindowScreenGui = Root.PseudoWindowScreenGui :: any
							local PseudoWindow: Frame = PseudoWindowScreenGui.PseudoWindow

							NumNonWindowChildren += 1
							PseudoWindow.Visible = true

							return PseudoWindow
						end
					end,
					ChildDiscarded = function(thisWidget: Widget, childWidget: Widget)
						if childWidget.type ~= "Window" and childWidget.type ~= "Tooltip" and childWidget.type ~= "MenuBar" then
							NumNonWindowChildren -= 1
							if NumNonWindowChildren == 0 then
								local Root = thisWidget.Instance :: any
								local PseudoWindowScreenGui = Root.PseudoWindowScreenGui :: any
								local PseudoWindow: Frame = PseudoWindowScreenGui.PseudoWindow
								PseudoWindow.Visible = false
							end
						end
					end,
				} :: WidgetClass)
			end
		end)()
		local window = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local function relocateTooltips()
					if Iris._rootInstance == nil then
						return
					end
					local PopupScreenGui = Iris._rootInstance:FindFirstChild("PopupScreenGui")
					local TooltipContainer = PopupScreenGui.TooltipContainer
					local mouseLocation: Vector2 = widgets.getMouseLocation()
					local newPosition: Vector2 = widgets.findBestWindowPosForPopup(mouseLocation, TooltipContainer.AbsoluteSize, Iris._config.DisplaySafeAreaPadding, PopupScreenGui.AbsoluteSize)
					TooltipContainer.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
				end
			
				widgets.registerEvent("InputChanged", function()
					if not Iris._started then
						return
					end
					relocateTooltips()
				end)
			
				--stylua: ignore
				Iris.WidgetConstructor("Tooltip", {
					hasState = false,
					hasChildren = false,
					Args = {
						["Text"] = 1,
					},
					Events = {},
					Generate = function(thisWidget: Widget)
						thisWidget.parentWidget = Iris._rootWidget -- only allow root as parent
			
						local Tooltip: Frame = Instance.new("Frame")
						Tooltip.Name = "Iris_Tooltip"
						Tooltip.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
						Tooltip.AutomaticSize = Enum.AutomaticSize.Y
						Tooltip.BorderSizePixel = 0
						Tooltip.BackgroundTransparency = 1
						Tooltip.ZIndex = thisWidget.ZIndex + 1
						Tooltip.LayoutOrder = thisWidget.ZIndex + 1
			
						local TooltipText: TextLabel = Instance.new("TextLabel")
						TooltipText.Name = "TooltipText"
						TooltipText.Size = UDim2.fromOffset(0, 0)
						TooltipText.AutomaticSize = Enum.AutomaticSize.XY
						TooltipText.BackgroundColor3 = Iris._config.WindowBgColor
						TooltipText.BackgroundTransparency = Iris._config.WindowBgTransparency
						TooltipText.BorderSizePixel = Iris._config.PopupBorderSize
						TooltipText.TextWrapped = Iris._config.TextWrapped
						TooltipText.ZIndex = thisWidget.ZIndex + 1
						TooltipText.LayoutOrder = thisWidget.ZIndex + 1
			
						widgets.applyTextStyle(TooltipText)
						widgets.UIStroke(TooltipText, Iris._config.WindowBorderSize, Iris._config.BorderActiveColor, Iris._config.BorderActiveTransparency)
						widgets.UIPadding(TooltipText, Iris._config.WindowPadding)
						if Iris._config.PopupRounding > 0 then
							widgets.UICorner(TooltipText, Iris._config.PopupRounding)
						end
			
						TooltipText.Parent = Tooltip
			
						return Tooltip
					end,
					Update = function(thisWidget: Widget)
						local Tooltip = thisWidget.Instance :: Frame
						local TooltipText: TextLabel = Tooltip.TooltipText
						if thisWidget.arguments.Text == nil then
							error("Iris.Text Text Argument is required", 5)
						end
						TooltipText.Text = thisWidget.arguments.Text
						relocateTooltips()
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			
				local windowDisplayOrder: number = 0 -- incremental count which is used for determining focused windows ZIndex
				local dragWindow: Widget? -- window being dragged, may be nil
				local isDragging: boolean = false
				local moveDeltaCursorPosition: Vector2 -- cursor offset from drag origin (top left of window)
			
				local resizeWindow: Widget? -- window being resized, may be nil
				local isResizing = false
				local isInsideResize = false -- is cursor inside of the focused window resize outer padding
				local isInsideWindow = false -- is cursor inside of the focused window
				local resizeFromTopBottom: Enum.TopBottom = Enum.TopBottom.Top
				local resizeFromLeftRight: Enum.LeftRight = Enum.LeftRight.Left
			
				local lastCursorPosition: Vector2
			
				local focusedWindow: Widget? -- window with focus, may be nil
				local anyFocusedWindow: boolean = false -- is there any focused window?
			
				local windowWidgets: { [ID]: Widget } = {} -- array of widget objects of type window
			
				local function quickSwapWindows()
					-- ctrl + tab swapping functionality
					if Iris._config.UseScreenGUIs == false then
						return
					end
			
					local lowest: number = 0xFFFF
					local lowestWidget: Widget
			
					for _, widget: Widget in windowWidgets do
						if widget.state.isOpened.value and not widget.arguments.NoNav then
							if widget.Instance:IsA("ScreenGui") then
								local value: number = widget.Instance.DisplayOrder
								if value < lowest then
									lowest = value
									lowestWidget = widget
								end
							end
						end
					end
			
					if lowestWidget.state.isUncollapsed.value == false then
						lowestWidget.state.isUncollapsed:set(true)
					end
					Iris.SetFocusedWindow(lowestWidget)
				end
			
				local function fitSizeToWindowBounds(thisWidget: Widget, intentedSize: Vector2): Vector2
					local windowSize: Vector2 = Vector2.new(thisWidget.state.position.value.X, thisWidget.state.position.value.Y)
					local minWindowSize: number = (Iris._config.TextSize + Iris._config.FramePadding.Y * 2) * 2
					local usableSize: Vector2 = widgets.getScreenSizeForWindow(thisWidget)
					local safeAreaPadding: Vector2 = Vector2.new(Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.X, Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.Y)
			
					local maxWindowSize: Vector2 = (usableSize - windowSize - safeAreaPadding)
					return Vector2.new(math.clamp(intentedSize.X, minWindowSize, math.max(maxWindowSize.X, minWindowSize)), math.clamp(intentedSize.Y, minWindowSize, math.max(maxWindowSize.Y, minWindowSize)))
				end
			
				local function fitPositionToWindowBounds(thisWidget: Widget, intendedPosition: Vector2): Vector2
					local thisWidgetInstance = thisWidget.Instance
					local usableSize: Vector2 = widgets.getScreenSizeForWindow(thisWidget)
					local safeAreaPadding: Vector2 = Vector2.new(Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.X, Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.Y)
			
					return Vector2.new(
						math.clamp(intendedPosition.X, safeAreaPadding.X, math.max(safeAreaPadding.X, usableSize.X - thisWidgetInstance.WindowButton.AbsoluteSize.X - safeAreaPadding.X)),
						math.clamp(intendedPosition.Y, safeAreaPadding.Y, math.max(safeAreaPadding.Y, usableSize.Y - thisWidgetInstance.WindowButton.AbsoluteSize.Y - safeAreaPadding.Y))
					)
				end
			
				Iris.SetFocusedWindow = function(thisWidget: Widget?)
					if focusedWindow == thisWidget then
						return
					end
			
					if anyFocusedWindow and focusedWindow ~= nil then
						if windowWidgets[focusedWindow.ID] then
							local Window = focusedWindow.Instance :: Frame
							local WindowButton = Window.WindowButton :: TextButton
							local Content = WindowButton.Content :: Frame
							local TitleBar: Frame = Content.TitleBar
							-- update appearance to unfocus
							if focusedWindow.state.isUncollapsed.value then
								TitleBar.BackgroundColor3 = Iris._config.TitleBgColor
								TitleBar.BackgroundTransparency = Iris._config.TitleBgTransparency
							else
								TitleBar.BackgroundColor3 = Iris._config.TitleBgCollapsedColor
								TitleBar.BackgroundTransparency = Iris._config.TitleBgCollapsedTransparency
							end
							WindowButton.UIStroke.Color = Iris._config.BorderColor
						end
			
						anyFocusedWindow = false
						focusedWindow = nil
					end
			
					if thisWidget ~= nil then
						-- update appearance to focus
						anyFocusedWindow = true
						focusedWindow = thisWidget
						local Window = thisWidget.Instance :: Frame
						local WindowButton = Window.WindowButton :: TextButton
						local Content = WindowButton.Content :: Frame
						local TitleBar: Frame = Content.TitleBar
			
						TitleBar.BackgroundColor3 = Iris._config.TitleBgActiveColor
						TitleBar.BackgroundTransparency = Iris._config.TitleBgActiveTransparency
						WindowButton.UIStroke.Color = Iris._config.BorderActiveColor
			
						windowDisplayOrder += 1
						if thisWidget.usesScreenGUI then
							Window.DisplayOrder = windowDisplayOrder + Iris._config.DisplayOrderOffset
						else
							Window.ZIndex = windowDisplayOrder + Iris._config.DisplayOrderOffset
						end
			
						if thisWidget.state.isUncollapsed.value == false then
							thisWidget.state.isUncollapsed:set(true)
						end
			
						local firstSelectedObject: GuiObject? = widgets.GuiService.SelectedObject
						if firstSelectedObject then
							if TitleBar.Visible then
								widgets.GuiService:Select(TitleBar)
							else
								widgets.GuiService:Select(Window.ChildContainer)
							end
						end
					end
				end
			
				widgets.registerEvent("InputBegan", function(input: InputObject)
					if not Iris._started then
						return
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local inWindow: boolean = false
						local position: Vector2 = widgets.getMouseLocation()
						for _, window in windowWidgets do
							local ResizeBorder: TextButton = window.Instance and window.Instance.WindowButton.ResizeBorder
							if ResizeBorder and widgets.isPosInsideRect(position, ResizeBorder.AbsolutePosition, ResizeBorder.AbsolutePosition + ResizeBorder.AbsoluteSize) then
								inWindow = true
								break
							end
						end
			
						if not inWindow then
							Iris.SetFocusedWindow(nil)
						end
					end
			
					if input.KeyCode == Enum.KeyCode.Tab and (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
						quickSwapWindows()
					end
			
					if input.UserInputType == Enum.UserInputType.MouseButton1 and isInsideResize and not isInsideWindow and anyFocusedWindow and focusedWindow then
						local midWindow: Vector2 = focusedWindow.state.position.value + (focusedWindow.state.size.value / 2)
						local cursorPosition: Vector2 = widgets.getMouseLocation() - midWindow
			
						-- check which axis its closest to, then check which side is closest with math.sign
						if math.abs(cursorPosition.X) * focusedWindow.state.size.value.Y >= math.abs(cursorPosition.Y) * focusedWindow.state.size.value.X then
							resizeFromTopBottom = Enum.TopBottom.Center
							resizeFromLeftRight = if math.sign(cursorPosition.X) == -1 then Enum.LeftRight.Left else Enum.LeftRight.Right
						else
							resizeFromLeftRight = Enum.LeftRight.Center
							resizeFromTopBottom = if math.sign(cursorPosition.Y) == -1 then Enum.TopBottom.Top else Enum.TopBottom.Bottom
						end
						isResizing = true
						resizeWindow = focusedWindow
					end
				end)
			
				widgets.registerEvent("TouchTapInWorld", function(_, gameProcessedEvent: boolean)
					if not Iris._started then
						return
					end
					if not gameProcessedEvent then
						Iris.SetFocusedWindow(nil)
					end
				end)
			
				widgets.registerEvent("InputChanged", function(input: InputObject)
					if not Iris._started then
						return
					end
					if isDragging and dragWindow then
						local mouseLocation: Vector2
						if input.UserInputType == Enum.UserInputType.Touch then
							local location: Vector3 = input.Position
							mouseLocation = Vector2.new(location.X, location.Y)
						else
							mouseLocation = widgets.getMouseLocation()
						end
						local Window = dragWindow.Instance :: Frame
						local dragInstance: TextButton = Window.WindowButton
						local intendedPosition: Vector2 = mouseLocation - moveDeltaCursorPosition
						local newPos: Vector2 = fitPositionToWindowBounds(dragWindow, intendedPosition)
			
						-- state shouldnt be used like this, but calling :set would run the entire UpdateState function for the window, which is slow.
						dragInstance.Position = UDim2.fromOffset(newPos.X, newPos.Y)
						dragWindow.state.position.value = newPos
					end
					if isResizing and resizeWindow and resizeWindow.arguments.NoResize ~= true then
						local Window = resizeWindow.Instance :: Frame
						local resizeInstance: TextButton = Window.WindowButton
						local windowPosition: Vector2 = Vector2.new(resizeInstance.Position.X.Offset, resizeInstance.Position.Y.Offset)
						local windowSize: Vector2 = Vector2.new(resizeInstance.Size.X.Offset, resizeInstance.Size.Y.Offset)
			
						local mouseDelta: Vector2 | Vector3
						if input.UserInputType == Enum.UserInputType.Touch then
							mouseDelta = input.Delta
						else
							mouseDelta = widgets.getMouseLocation() - lastCursorPosition
						end
			
						local intendedPosition: Vector2 = windowPosition + Vector2.new(if resizeFromLeftRight == Enum.LeftRight.Left then mouseDelta.X else 0, if resizeFromTopBottom == Enum.TopBottom.Top then mouseDelta.Y else 0)
			
						local intendedSize: Vector2 = windowSize
							+ Vector2.new(
								if resizeFromLeftRight == Enum.LeftRight.Left then -mouseDelta.X elseif resizeFromLeftRight == Enum.LeftRight.Right then mouseDelta.X else 0,
								if resizeFromTopBottom == Enum.TopBottom.Top then -mouseDelta.Y elseif resizeFromTopBottom == Enum.TopBottom.Bottom then mouseDelta.Y else 0
							)
			
						local newSize: Vector2 = fitSizeToWindowBounds(resizeWindow, intendedSize)
						local newPosition: Vector2 = fitPositionToWindowBounds(resizeWindow, intendedPosition)
			
						resizeInstance.Size = UDim2.fromOffset(newSize.X, newSize.Y)
						resizeWindow.state.size.value = newSize
						resizeInstance.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
						resizeWindow.state.position.value = newPosition
					end
			
					lastCursorPosition = widgets.getMouseLocation()
				end)
			
				widgets.registerEvent("InputEnded", function(input, _)
					if not Iris._started then
						return
					end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging and dragWindow then
						local Window = dragWindow.Instance :: Frame
						local dragInstance: TextButton = Window.WindowButton
						isDragging = false
						dragWindow.state.position:set(Vector2.new(dragInstance.Position.X.Offset, dragInstance.Position.Y.Offset))
					end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isResizing and resizeWindow then
						local Window = resizeWindow.Instance :: Frame
						isResizing = false
						resizeWindow.state.size:set(Window.WindowButton.AbsoluteSize)
					end
			
					if input.KeyCode == Enum.KeyCode.ButtonX then
						quickSwapWindows()
					end
				end)
			
				--stylua: ignore
				Iris.WidgetConstructor("Window", {
					hasState = true,
					hasChildren = true,
					Args = {
						["Title"] = 1,
						["NoTitleBar"] = 2,
						["NoBackground"] = 3,
						["NoCollapse"] = 4,
						["NoClose"] = 5,
						["NoMove"] = 6,
						["NoScrollbar"] = 7,
						["NoResize"] = 8,
						["NoNav"] = 9,
						["NoMenu"] = 10,
					},
					Events = {
						["closed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastClosedTick == Iris._cycleTick
							end,
						},
						["opened"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastOpenedTick == Iris._cycleTick
							end,
						},
						["collapsed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastCollapsedTick == Iris._cycleTick
							end,
						},
						["uncollapsed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastUncollapsedTick == Iris._cycleTick
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							local Window = thisWidget.Instance :: Frame
							return Window.WindowButton
						end),
					},
					Generate = function(thisWidget: Widget)
						thisWidget.parentWidget = Iris._rootWidget -- only allow root as parent
			
						thisWidget.usesScreenGUI = Iris._config.UseScreenGUIs
						windowWidgets[thisWidget.ID] = thisWidget
			
						local Window
						if thisWidget.usesScreenGUI then
							Window = Instance.new("ScreenGui")
							Window.ResetOnSpawn = false
							Window.DisplayOrder = Iris._config.DisplayOrderOffset
							Window.IgnoreGuiInset = Iris._config.IgnoreGuiInset
						else
							Window = Instance.new("Frame")
							Window.AnchorPoint = Vector2.new(0.5, 0.5)
							Window.Position = UDim2.new(0.5, 0, 0.5, 0)
							Window.Size = UDim2.new(1, 0, 1, 0)
							Window.BackgroundTransparency = 1
							Window.ZIndex = Iris._config.DisplayOrderOffset
						end
						Window.Name = "Iris_Window"
			
						local WindowButton: TextButton = Instance.new("TextButton")
						WindowButton.Name = "WindowButton"
						WindowButton.Size = UDim2.fromOffset(0, 0)
						WindowButton.BackgroundTransparency = 1
						WindowButton.BorderSizePixel = 0
						WindowButton.Text = ""
						WindowButton.ClipsDescendants = false
						WindowButton.AutoButtonColor = false
						WindowButton.Selectable = false
						WindowButton.SelectionImageObject = Iris.SelectionImageObject
						WindowButton.ZIndex = thisWidget.ZIndex + 1
						WindowButton.LayoutOrder = thisWidget.ZIndex + 1
			
						WindowButton.SelectionGroup = true
						WindowButton.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
						WindowButton.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
						WindowButton.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
						WindowButton.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			
						widgets.UIStroke(WindowButton, Iris._config.WindowBorderSize, Iris._config.BorderColor, Iris._config.BorderTransparency)
			
						WindowButton.Parent = Window
			
						widgets.applyInputBegan(thisWidget, WindowButton, function(input: InputObject)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Keyboard then
								return
							end
							if thisWidget.state.isUncollapsed.value then
								Iris.SetFocusedWindow(thisWidget)
							end
							if not thisWidget.arguments.NoMove and input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragWindow = thisWidget
								isDragging = true
								moveDeltaCursorPosition = widgets.getMouseLocation() - thisWidget.state.position.value
							end
						end)
			
						local Content: Frame = Instance.new("Frame")
						Content.Name = "Content"
						Content.AnchorPoint = Vector2.new(0.5, 0.5)
						Content.Position = UDim2.fromScale(0.5, 0.5)
						Content.Size = UDim2.fromScale(1, 1)
						Content.BackgroundTransparency = 1
						Content.ClipsDescendants = true
						Content.Parent = WindowButton
			
						local UIListLayout: UIListLayout = widgets.UIListLayout(Content, Enum.FillDirection.Vertical, UDim.new(0, 0))
						UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
						UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			
						local ChildContainer: ScrollingFrame = Instance.new("ScrollingFrame")
						ChildContainer.Name = "ChildContainer"
						ChildContainer.AutomaticSize = Enum.AutomaticSize.None
						ChildContainer.Size = UDim2.fromScale(1, 1)
						ChildContainer.Position = UDim2.fromOffset(0, 0)
						ChildContainer.BackgroundColor3 = Iris._config.WindowBgColor
						ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
						ChildContainer.BorderSizePixel = 0
			
						ChildContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
						ChildContainer.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency
						ChildContainer.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
						ChildContainer.CanvasSize = UDim2.fromScale(0, 0)
						ChildContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			
						ChildContainer.ZIndex = thisWidget.ZIndex + 3
						ChildContainer.LayoutOrder = thisWidget.ZIndex + 3
						ChildContainer.ClipsDescendants = true
			
						widgets.UIPadding(ChildContainer, Iris._config.WindowPadding)
			
						ChildContainer.Parent = Content
			
						local UIFlexItem: UIFlexItem = Instance.new("UIFlexItem")
						UIFlexItem.FlexMode = Enum.UIFlexMode.Fill
						UIFlexItem.ItemLineAlignment = Enum.ItemLineAlignment.End
						UIFlexItem.Parent = ChildContainer
			
						ChildContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
							-- "wrong" use of state here, for optimization
							thisWidget.state.scrollDistance.value = ChildContainer.CanvasPosition.Y
						end)
			
						widgets.applyInputBegan(thisWidget, ChildContainer, function(input: InputObject)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Keyboard then
								return
							end
							if thisWidget.state.isUncollapsed.value then
								Iris.SetFocusedWindow(thisWidget)
							end
						end)
			
						local TerminatingFrame: Frame = Instance.new("Frame")
						TerminatingFrame.Name = "TerminatingFrame"
						TerminatingFrame.Size = UDim2.fromOffset(0, Iris._config.WindowPadding.Y + Iris._config.FramePadding.Y)
						TerminatingFrame.BackgroundTransparency = 1
						TerminatingFrame.BorderSizePixel = 0
						TerminatingFrame.LayoutOrder = 0x7FFFFFF0
			
						local ChildContainerUIListLayout: UIListLayout = widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
						ChildContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			
						TerminatingFrame.Parent = ChildContainer
			
						local TitleBar: Frame = Instance.new("Frame")
						TitleBar.Name = "TitleBar"
						TitleBar.Size = UDim2.fromScale(1, 0)
						TitleBar.AutomaticSize = Enum.AutomaticSize.Y
						TitleBar.BorderSizePixel = 0
						TitleBar.ZIndex = thisWidget.ZIndex + 1
						TitleBar.LayoutOrder = thisWidget.ZIndex + 1
						TitleBar.ClipsDescendants = true
			
						TitleBar.Parent = Content
			
						widgets.applyInputBegan(thisWidget, TitleBar, function(input: InputObject)
							if input.UserInputType == Enum.UserInputType.Touch then
								if not thisWidget.arguments.NoMove then
									dragWindow = thisWidget
									isDragging = true
									local location: Vector3 = input.Position
									moveDeltaCursorPosition = Vector2.new(location.X, location.Y) - thisWidget.state.position.value
								end
							end
						end)
			
						local TitleButtonSize: number = Iris._config.TextSize + ((Iris._config.FramePadding.Y - 1) * 2)
			
						local CollapseButton: TextButton = Instance.new("TextButton")
						CollapseButton.Name = "CollapseButton"
						CollapseButton.AnchorPoint = Vector2.new(0, 0.5)
						CollapseButton.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
						CollapseButton.Position = UDim2.new(0, Iris._config.FramePadding.X + 1, 0.5, 0)
						CollapseButton.AutomaticSize = Enum.AutomaticSize.None
						CollapseButton.BackgroundTransparency = 1
						CollapseButton.BorderSizePixel = 0
						CollapseButton.AutoButtonColor = false
						CollapseButton.Text = ""
						CollapseButton.ZIndex = thisWidget.ZIndex + 4
			
						widgets.UICorner(CollapseButton)
			
						CollapseButton.Parent = TitleBar
			
						widgets.applyButtonClick(thisWidget, CollapseButton, function()
							thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
						end)
			
						widgets.applyInteractionHighlights(thisWidget, CollapseButton, CollapseButton, {
							ButtonColor = Iris._config.ButtonColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.ButtonHoveredColor,
							ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
							ButtonActiveColor = Iris._config.ButtonActiveColor,
							ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
						})
			
						local CollapseArrow: ImageLabel = Instance.new("ImageLabel")
						CollapseArrow.Name = "Arrow"
						CollapseArrow.AnchorPoint = Vector2.new(0.5, 0.5)
						CollapseArrow.Size = UDim2.fromOffset(math.floor(0.7 * TitleButtonSize), math.floor(0.7 * TitleButtonSize))
						CollapseArrow.Position = UDim2.fromScale(0.5, 0.5)
						CollapseArrow.BackgroundTransparency = 1
						CollapseArrow.BorderSizePixel = 0
						CollapseArrow.Image = widgets.ICONS.MULTIPLICATION_SIGN
						CollapseArrow.ImageColor3 = Iris._config.TextColor
						CollapseArrow.ImageTransparency = Iris._config.TextTransparency
						CollapseArrow.ZIndex = thisWidget.ZIndex + 5
						CollapseArrow.Parent = CollapseButton
			
						local CloseButton: TextButton = Instance.new("TextButton")
						CloseButton.Name = "CloseButton"
						CloseButton.AnchorPoint = Vector2.new(1, 0.5)
						CloseButton.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
						CloseButton.Position = UDim2.new(1, -(Iris._config.FramePadding.X + 1), 0.5, 0)
						CloseButton.AutomaticSize = Enum.AutomaticSize.None
						CloseButton.BackgroundTransparency = 1
						CloseButton.BorderSizePixel = 0
						CloseButton.Text = ""
			
						CloseButton.ZIndex = thisWidget.ZIndex + 4
						CloseButton.AutoButtonColor = false
			
						widgets.UICorner(CloseButton)
			
						widgets.applyButtonClick(thisWidget, CloseButton, function()
							thisWidget.state.isOpened:set(false)
						end)
			
						widgets.applyInteractionHighlights(thisWidget, CloseButton, CloseButton, {
							ButtonColor = Iris._config.ButtonColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.ButtonHoveredColor,
							ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
							ButtonActiveColor = Iris._config.ButtonActiveColor,
							ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
						})
			
						CloseButton.Parent = TitleBar
			
						local CloseIcon: ImageLabel = Instance.new("ImageLabel")
						CloseIcon.Name = "Icon"
						CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
						CloseIcon.Size = UDim2.fromOffset(math.floor(0.7 * TitleButtonSize), math.floor(0.7 * TitleButtonSize))
						CloseIcon.Position = UDim2.fromScale(0.5, 0.5)
						CloseIcon.BackgroundTransparency = 1
						CloseIcon.BorderSizePixel = 0
						CloseIcon.Image = widgets.ICONS.MULTIPLICATION_SIGN
						CloseIcon.ImageColor3 = Iris._config.TextColor
						CloseIcon.ImageTransparency = Iris._config.TextTransparency
						CloseIcon.ZIndex = thisWidget.ZIndex + 5
						CloseIcon.Parent = CloseButton
			
						-- allowing fractional titlebar title location dosent seem useful, as opposed to Enum.LeftRight.
			
						local titleAlign: number
						if Iris._config.WindowTitleAlign == Enum.LeftRight.Left then
							titleAlign = 0
						elseif Iris._config.WindowTitleAlign == Enum.LeftRight.Center then
							titleAlign = 0.5
						else
							titleAlign = 1
						end
			
						local Title: TextLabel = Instance.new("TextLabel")
						Title.Name = "Title"
						Title.AnchorPoint = Vector2.new(titleAlign, 0)
						Title.Position = UDim2.fromScale(titleAlign, 0)
						Title.AutomaticSize = Enum.AutomaticSize.XY
						Title.BorderSizePixel = 0
						Title.BackgroundTransparency = 1
						Title.ZIndex = thisWidget.ZIndex + 3
			
						widgets.applyTextStyle(Title)
						widgets.UIPadding(Title, Iris._config.FramePadding)
			
						Title.Parent = TitleBar
			
						local ResizeButtonSize: number = Iris._config.TextSize + Iris._config.FramePadding.X
			
						local ResizeGrip = Instance.new("TextButton")
						ResizeGrip.Name = "ResizeGrip"
						ResizeGrip.AnchorPoint = Vector2.new(1, 1)
						ResizeGrip.Size = UDim2.fromOffset(ResizeButtonSize, ResizeButtonSize)
						ResizeGrip.Position = UDim2.fromScale(1, 1)
						ResizeGrip.AutoButtonColor = false
						ResizeGrip.BorderSizePixel = 0
						ResizeGrip.BackgroundTransparency = 1
						ResizeGrip.Text = widgets.ICONS.BOTTOM_RIGHT_CORNER
						ResizeGrip.TextSize = ResizeButtonSize
						ResizeGrip.TextColor3 = Iris._config.ButtonColor
						ResizeGrip.TextTransparency = Iris._config.ButtonTransparency
						ResizeGrip.LineHeight = 1.10 -- fix mild rendering issue
						ResizeGrip.Selectable = false
						ResizeGrip.ZIndex = thisWidget.ZIndex + 3
						ResizeGrip.Parent = WindowButton
			
						widgets.applyTextInteractionHighlights(thisWidget, ResizeGrip, ResizeGrip, {
							ButtonColor = Iris._config.ButtonColor,
							ButtonTransparency = Iris._config.ButtonTransparency,
							ButtonHoveredColor = Iris._config.ButtonHoveredColor,
							ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
							ButtonActiveColor = Iris._config.ButtonActiveColor,
							ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
						})
			
						widgets.applyButtonDown(thisWidget, ResizeGrip, function()
							if not anyFocusedWindow or not (focusedWindow == thisWidget) then
								Iris.SetFocusedWindow(thisWidget)
								-- mitigating wrong focus when clicking on buttons inside of a window without clicking the window itself
							end
							isResizing = true
							resizeFromTopBottom = Enum.TopBottom.Bottom
							resizeFromLeftRight = Enum.LeftRight.Right
							resizeWindow = thisWidget
						end)
			
						local ResizeBorder: Frame = Instance.new("Frame")
						ResizeBorder.Name = "ResizeBorder"
						ResizeBorder.Size = UDim2.new(1, Iris._config.WindowResizePadding.X * 2, 1, Iris._config.WindowResizePadding.Y * 2)
						ResizeBorder.Position = UDim2.fromOffset(-Iris._config.WindowResizePadding.X, -Iris._config.WindowResizePadding.Y)
						ResizeBorder.BackgroundTransparency = 1
						ResizeBorder.BorderSizePixel = 0
						ResizeBorder.Active = true
						ResizeBorder.Selectable = false
						ResizeBorder.ZIndex = thisWidget.ZIndex
						ResizeBorder.LayoutOrder = thisWidget.ZIndex
						ResizeBorder.ClipsDescendants = false
						ResizeBorder.Parent = WindowButton
			
						widgets.applyMouseEnter(thisWidget, ResizeBorder, function()
							if focusedWindow == thisWidget then
								isInsideResize = true
							end
						end)
						widgets.applyMouseLeave(thisWidget, ResizeBorder, function()
							if focusedWindow == thisWidget then
								isInsideResize = false
							end
						end)
			
						widgets.applyMouseEnter(thisWidget, WindowButton, function()
							if focusedWindow == thisWidget then
								isInsideWindow = true
							end
						end)
						widgets.applyMouseLeave(thisWidget, WindowButton, function()
							if focusedWindow == thisWidget then
								isInsideWindow = false
							end
						end)
			
						return Window
					end,
					Update = function(thisWidget: Widget)
						local WindowGui = thisWidget.Instance :: GuiObject
						local WindowButton = WindowGui.WindowButton :: TextButton
						local Content = WindowButton.Content :: Frame
						local TitleBar = Content.TitleBar :: Frame
						local Title: TextLabel = TitleBar.Title
						local MenuBar: Frame? = Content:FindFirstChild("MenuBar")
						local ChildContainer: ScrollingFrame = Content.ChildContainer
						local ResizeGrip: TextButton = WindowButton.ResizeGrip
			
						if thisWidget.arguments.NoResize ~= true then
							ResizeGrip.Visible = true
						else
							ResizeGrip.Visible = false
						end
						if thisWidget.arguments.NoScrollbar then
							ChildContainer.ScrollBarThickness = 0
						else
							ChildContainer.ScrollBarThickness = Iris._config.ScrollbarSize
						end
						if thisWidget.arguments.NoTitleBar then
							TitleBar.Visible = false
						else
							TitleBar.Visible = true
						end
						if MenuBar then
							if thisWidget.arguments.NoMenu then
								MenuBar.Visible = false
							else
								MenuBar.Visible = true
							end
						end
						if thisWidget.arguments.NoBackground then
							ChildContainer.BackgroundTransparency = 1
						else
							ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
						end
			
						-- TitleBar buttons
						local TitleButtonPaddingSize = Iris._config.FramePadding.X + Iris._config.TextSize + Iris._config.FramePadding.X * 2
						if thisWidget.arguments.NoCollapse then
							TitleBar.CollapseButton.Visible = false
							TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, Iris._config.FramePadding.X)
						else
							TitleBar.CollapseButton.Visible = true
							TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, TitleButtonPaddingSize)
						end
						if thisWidget.arguments.NoClose then
							TitleBar.CloseButton.Visible = false
							TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, Iris._config.FramePadding.X)
						else
							TitleBar.CloseButton.Visible = true
							TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, TitleButtonPaddingSize)
						end
			
						Title.Text = thisWidget.arguments.Title or ""
					end,
					Discard = function(thisWidget: Widget)
						if focusedWindow == thisWidget then
							focusedWindow = nil
							anyFocusedWindow = false
						end
						if dragWindow == thisWidget then
							dragWindow = nil
							isDragging = false
						end
						if resizeWindow == thisWidget then
							resizeWindow = nil
							isResizing = false
						end
						windowWidgets[thisWidget.ID] = nil
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					ChildAdded = function(thisWidget: Widget, thisChid: Widget)
						local Window = thisWidget.Instance :: Frame
						local WindowButton = Window.WindowButton :: TextButton
						local Content = WindowButton.Content :: Frame
						if thisChid.type == "MenuBar" then
							local ChildContainer: ScrollingFrame = Content.ChildContainer
							thisChid.Instance.ZIndex = ChildContainer.ZIndex - 1
							thisChid.Instance.LayoutOrder = ChildContainer.LayoutOrder - 1
							return Content
						end
						return Content.ChildContainer
					end,
					UpdateState = function(thisWidget: Widget)
						local stateSize: Vector2 = thisWidget.state.size.value
						local statePosition: Vector2 = thisWidget.state.position.value
						local stateIsUncollapsed: boolean = thisWidget.state.isUncollapsed.value
						local stateIsOpened: boolean = thisWidget.state.isOpened.value
						local stateScrollDistance: number = thisWidget.state.scrollDistance.value
			
						local Window = thisWidget.Instance :: Frame
						local WindowButton = Window.WindowButton :: TextButton
						local Content = WindowButton.Content :: Frame
						local TitleBar = Content.TitleBar :: Frame
						local MenuBar: Frame? = Content:FindFirstChild("MenuBar")
						local ChildContainer: ScrollingFrame = Content.ChildContainer
						local ResizeGrip: TextButton = WindowButton.ResizeGrip
			
						WindowButton.Size = UDim2.fromOffset(stateSize.X, stateSize.Y)
						WindowButton.Position = UDim2.fromOffset(statePosition.X, statePosition.Y)
			
						if stateIsOpened then
							if thisWidget.usesScreenGUI then
								Window.Enabled = true
								WindowButton.Visible = true
							else
								Window.Visible = true
								WindowButton.Visible = true
							end
							thisWidget.lastOpenedTick = Iris._cycleTick + 1
						else
							if thisWidget.usesScreenGUI then
								Window.Enabled = false
								WindowButton.Visible = false
							else
								Window.Visible = false
								WindowButton.Visible = false
							end
							thisWidget.lastClosedTick = Iris._cycleTick + 1
						end
			
						if stateIsUncollapsed then
							TitleBar.CollapseButton.Arrow.Image = widgets.ICONS.DOWN_POINTING_TRIANGLE
							if MenuBar then
								MenuBar.Visible = not thisWidget.arguments.NoMenu
							end
							ChildContainer.Visible = true
							if thisWidget.arguments.NoResize ~= true then
								ResizeGrip.Visible = true
							end
							WindowButton.AutomaticSize = Enum.AutomaticSize.None
							thisWidget.lastUncollapsedTick = Iris._cycleTick + 1
						else
							local collapsedHeight: number = TitleBar.AbsoluteSize.Y -- Iris._config.TextSize + Iris._config.FramePadding.Y * 2
							TitleBar.CollapseButton.Arrow.Image = widgets.ICONS.RIGHT_POINTING_TRIANGLE
			
							if MenuBar then
								MenuBar.Visible = false
							end
							ChildContainer.Visible = false
							ResizeGrip.Visible = false
							WindowButton.Size = UDim2.fromOffset(stateSize.X, collapsedHeight)
							thisWidget.lastCollapsedTick = Iris._cycleTick + 1
						end
			
						if stateIsOpened and stateIsUncollapsed then
							Iris.SetFocusedWindow(thisWidget)
						else
							TitleBar.BackgroundColor3 = Iris._config.TitleBgCollapsedColor
							TitleBar.BackgroundTransparency = Iris._config.TitleBgCollapsedTransparency
							WindowButton.UIStroke.Color = Iris._config.BorderColor
			
							Iris.SetFocusedWindow(nil)
						end
			
						-- cant update canvasPosition in this cycle because scrollingframe isint ready to be changed
						if stateScrollDistance and stateScrollDistance ~= 0 then
							local callbackIndex: number = #Iris._postCycleCallbacks + 1
							local desiredCycleTick: number = Iris._cycleTick + 1
							Iris._postCycleCallbacks[callbackIndex] = function()
								if Iris._cycleTick == desiredCycleTick then
									ChildContainer.CanvasPosition = Vector2.new(0, stateScrollDistance)
									Iris._postCycleCallbacks[callbackIndex] = nil
								end
							end
						end
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.size == nil then
							thisWidget.state.size = Iris._widgetState(thisWidget, "size", Vector2.new(400, 300))
						end
						if thisWidget.state.position == nil then
							thisWidget.state.position = Iris._widgetState(thisWidget, "position", if anyFocusedWindow and focusedWindow then focusedWindow.state.position.value + Vector2.new(15, 45) else Vector2.new(150, 250))
						end
						thisWidget.state.position.value = fitPositionToWindowBounds(thisWidget, thisWidget.state.position.value)
						thisWidget.state.size.value = fitSizeToWindowBounds(thisWidget, thisWidget.state.size.value)
			
						if thisWidget.state.isUncollapsed == nil then
							thisWidget.state.isUncollapsed = Iris._widgetState(thisWidget, "isUncollapsed", true)
						end
						if thisWidget.state.isOpened == nil then
							thisWidget.state.isOpened = Iris._widgetState(thisWidget, "isOpened", true)
						end
						if thisWidget.state.scrollDistance == nil then
							thisWidget.state.scrollDistance = Iris._widgetState(thisWidget, "scrollDistance", 0)
						end
					end,
				} :: WidgetClass)
			end
		end)()

		local menu = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local AnyMenuOpen: boolean = false
				local ActiveMenu: Widget? = nil
				local MenuStack: { Widget } = {}
			
				local function EmptyMenuStack(menuIndex: number?)
					for index = #MenuStack, menuIndex and menuIndex + 1 or 1, -1 do
						local widget: Widget = MenuStack[index]
						widget.state.isOpened:set(false)
			
						widget.Instance.BackgroundColor3 = Iris._config.HeaderColor
						widget.Instance.BackgroundTransparency = 1
			
						table.remove(MenuStack, index)
					end
			
					if #MenuStack == 0 then
						AnyMenuOpen = false
						ActiveMenu = nil
					end
				end
			
				local function UpdateChildContainerTransform(thisWidget: Widget)
					local submenu: boolean = thisWidget.parentWidget.type == "Menu"
			
					local Menu = thisWidget.Instance :: Frame
					local ChildContainer = thisWidget.ChildContainer :: ScrollingFrame
					ChildContainer.Size = UDim2.fromOffset(math.max(ChildContainer.AbsoluteSize.X, Menu.AbsoluteSize.X), math.max(ChildContainer.AbsoluteSize.Y, Menu.AbsoluteSize.Y))
					if ChildContainer.Parent == nil then
						return
					end
			
					local menuPosition: Vector2 = Menu.AbsolutePosition
					local menuSize: Vector2 = Menu.AbsoluteSize
					local containerSize: Vector2 = ChildContainer.AbsoluteSize
					local borderSize: number = Iris._config.PopupBorderSize
					local screenSize: Vector2 = ChildContainer.Parent.AbsoluteSize
			
					local x: number = menuPosition.X + borderSize
					local y: number
			
					if thisWidget.parentWidget.type == "Menu" then
						if menuPosition.X + containerSize.X > screenSize.X then
							x = menuPosition.X - borderSize - (submenu and containerSize.X or 0)
						else
							x = menuPosition.X + borderSize + (submenu and menuSize.X or 0)
						end
					end
			
					if menuPosition.Y + containerSize.Y > screenSize.Y then
						-- too low.
						y = menuPosition.Y - borderSize - containerSize.Y + (submenu and menuSize.Y or 0)
					else
						y = menuPosition.Y + borderSize + (submenu and 0 or menuSize.Y)
					end
			
					ChildContainer.Position = UDim2.fromOffset(x, y)
				end
			
				widgets.registerEvent("InputBegan", function(inputObject: InputObject)
					if not Iris._started then
						return
					end
					if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 then
						return
					end
					if AnyMenuOpen == false then
						return
					end
					if ActiveMenu == nil then
						return
					end
			
					-- this only checks if we clicked outside all the menus. If we clicked in any menu, then the hover function handles this.
					local isInMenu: boolean = false
					local MouseLocation: Vector2 = widgets.getMouseLocation()
					for _, menu: Widget in MenuStack do
						for _, container: GuiObject in { menu.ChildContainer, menu.Instance } do
							local rectMin: Vector2 = container.AbsolutePosition
							local rectMax: Vector2 = rectMin + container.AbsoluteSize
							if widgets.isPosInsideRect(MouseLocation, rectMin, rectMax) then
								isInMenu = true
								break
							end
						end
					end
			
					if not isInMenu then
						EmptyMenuStack()
					end
				end)
			
				--stylua: ignore
				Iris.WidgetConstructor("MenuBar", {
					hasState = false,
					hasChildren = true,
					Args = {},
					Events = {},
					Generate = function(thisWidget: Widget)
						local MenuBar: Frame = Instance.new("Frame")
						MenuBar.Name = "MenuBar"
						MenuBar.Size = UDim2.fromScale(1, 0)
						MenuBar.AutomaticSize = Enum.AutomaticSize.Y
						MenuBar.BackgroundColor3 = Iris._config.MenubarBgColor
						MenuBar.BackgroundTransparency = Iris._config.MenubarBgTransparency
						MenuBar.BorderSizePixel = 0
						MenuBar.ZIndex = thisWidget.ZIndex
						MenuBar.LayoutOrder = thisWidget.ZIndex
						MenuBar.ClipsDescendants = true
			
						widgets.UIPadding(MenuBar, Vector2.new(Iris._config.ItemSpacing.X, 2))
						widgets.UIListLayout(MenuBar, Enum.FillDirection.Horizontal, UDim.new()).VerticalAlignment = Enum.VerticalAlignment.Center
			
						return MenuBar
					end,
					Update = function()
						
					end,
					ChildAdded = function(thisWidget: Widget)
						return thisWidget.Instance
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("Menu", {
					hasState = true,
					hasChildren = true,
					Args = {
						["Text"] = 1,
					},
					Events = {
						["clicked"] = widgets.EVENTS.click(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["opened"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastOpenedTick == Iris._cycleTick
							end,
						},
						["closed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastClosedTick == Iris._cycleTick
							end,
						},
					},
					Generate = function(thisWidget: Widget)
						local Menu: TextButton
						thisWidget.ButtonColors = {
							ButtonColor = Iris._config.HeaderColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.HeaderHoveredColor,
							ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
							ButtonActiveColor = Iris._config.HeaderHoveredColor,
							ButtonActiveTransparency = Iris._config.HeaderHoveredTransparency,
						}
						if thisWidget.parentWidget.type == "Menu" then
							-- this Menu is a sub-Menu
							Menu = Instance.new("TextButton")
							Menu.Name = "Menu"
							Menu.BackgroundColor3 = Iris._config.HeaderColor
							Menu.BackgroundTransparency = 1
							Menu.BorderSizePixel = 0
							Menu.Size = UDim2.fromScale(1, 0)
							Menu.Text = ""
							Menu.AutomaticSize = Enum.AutomaticSize.Y
							Menu.ZIndex = thisWidget.ZIndex
							Menu.LayoutOrder = thisWidget.ZIndex
							Menu.AutoButtonColor = false
			
							local UIPadding = widgets.UIPadding(Menu, Iris._config.FramePadding)
							UIPadding.PaddingTop = UIPadding.PaddingTop - UDim.new(0, 1)
							widgets.UIListLayout(Menu, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center
			
							local TextLabel: TextLabel = Instance.new("TextLabel")
							TextLabel.Name = "TextLabel"
							TextLabel.AnchorPoint = Vector2.new(0, 0)
							TextLabel.BackgroundTransparency = 1
							TextLabel.BorderSizePixel = 0
							TextLabel.ZIndex = thisWidget.ZIndex + 2
							TextLabel.LayoutOrder = thisWidget.ZIndex + 2
							TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			
							widgets.applyTextStyle(TextLabel)
			
							TextLabel.Parent = Menu
			
							local frameSize: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
							local padding: number = math.round(0.2 * frameSize)
							local iconSize: number = frameSize - 2 * padding
			
							local Icon: ImageLabel = Instance.new("ImageLabel")
							Icon.Name = "Icon"
							Icon.Size = UDim2.fromOffset(iconSize, iconSize)
							Icon.BackgroundTransparency = 1
							Icon.BorderSizePixel = 0
							Icon.ImageColor3 = Iris._config.TextColor
							Icon.ImageTransparency = Iris._config.TextTransparency
							Icon.Image = widgets.ICONS.RIGHT_POINTING_TRIANGLE
							Icon.ZIndex = thisWidget.ZIndex + 3
							Icon.LayoutOrder = thisWidget.ZIndex + 3
			
							Icon.Parent = Menu
						else
							Menu = Instance.new("TextButton")
							Menu.Name = "Menu"
							Menu.Size = UDim2.fromScale(0, 0)
							Menu.AutomaticSize = Enum.AutomaticSize.XY
							Menu.BackgroundColor3 = Iris._config.HeaderColor
							Menu.BackgroundTransparency = 1
							Menu.BorderSizePixel = 0
							Menu.Text = ""
							Menu.LayoutOrder = thisWidget.ZIndex
							Menu.ZIndex = thisWidget.ZIndex
							Menu.AutoButtonColor = false
							Menu.ClipsDescendants = true
			
							widgets.applyTextStyle(Menu)
							widgets.UIPadding(Menu, Vector2.new(Iris._config.ItemSpacing.X, Iris._config.FramePadding.Y))
						end
						widgets.applyInteractionHighlights(thisWidget, Menu, Menu, thisWidget.ButtonColors)
			
						widgets.applyButtonClick(thisWidget, Menu, function()
							local openMenu: boolean = if #MenuStack <= 1 then not thisWidget.state.isOpened.value else true
							thisWidget.state.isOpened:set(openMenu)
			
							AnyMenuOpen = openMenu
							ActiveMenu = openMenu and thisWidget or nil
							-- the hovering should handle all of the menus after the first one.
							if #MenuStack <= 1 then
								if openMenu then
									table.insert(MenuStack, thisWidget)
								else
									table.remove(MenuStack)
								end
							end
						end)
						widgets.applyMouseEnter(thisWidget, Menu, function()
							if AnyMenuOpen and ActiveMenu and ActiveMenu ~= thisWidget then
								local parentMenu: Widget = thisWidget.parentWidget
								local parentIndex: number? = table.find(MenuStack, parentMenu)
			
								EmptyMenuStack(parentIndex)
								thisWidget.state.isOpened:set(true)
								ActiveMenu = thisWidget
								AnyMenuOpen = true
								table.insert(MenuStack, thisWidget)
							end
						end)
			
						local ChildContainer: ScrollingFrame = Instance.new("ScrollingFrame")
						ChildContainer.Name = "ChildContainer"
						ChildContainer.BackgroundColor3 = Iris._config.WindowBgColor
						ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
						ChildContainer.BorderSizePixel = 0
						ChildContainer.Size = UDim2.fromOffset(0, 0)
						ChildContainer.AutomaticSize = Enum.AutomaticSize.XY
			
						ChildContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
						ChildContainer.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency
						ChildContainer.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
						ChildContainer.ScrollBarThickness = Iris._config.ScrollbarSize
						ChildContainer.CanvasSize = UDim2.fromScale(0, 0)
						ChildContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			
						ChildContainer.ZIndex = thisWidget.ZIndex + 6
						ChildContainer.LayoutOrder = thisWidget.ZIndex + 6
						ChildContainer.ClipsDescendants = true
			
						-- Unfortunatley, ScrollingFrame does not work with UICorner
						-- if Iris._config.PopupRounding > 0 then
						--     widgets.UICorner(ChildContainer, Iris._config.PopupRounding)
						-- end
			
						local ChildContainerUIListLayout: UIListLayout = widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, 1))
						ChildContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			
						local RootPopupScreenGui = Iris._rootInstance and Iris._rootInstance:FindFirstChild("PopupScreenGui") :: GuiObject
						ChildContainer.Parent = RootPopupScreenGui
						thisWidget.ChildContainer = ChildContainer
			
						widgets.UIStroke(ChildContainer, Iris._config.WindowBorderSize, Iris._config.BorderColor, Iris._config.BorderTransparency)
						widgets.UIPadding(ChildContainer, Vector2.new(2, Iris._config.WindowPadding.Y - Iris._config.ItemSpacing.Y))
			
						return Menu
					end,
					Update = function(thisWidget: Widget)
						local Menu = thisWidget.Instance :: TextButton
						local TextLabel: TextLabel
						if thisWidget.parentWidget.type == "Menu" then
							TextLabel = Menu.TextLabel
						else
							TextLabel = Menu
						end
						TextLabel.Text = thisWidget.arguments.Text or "Menu"
					end,
					ChildAdded = function(thisWidget: Widget, _thisChild: Widget)
						UpdateChildContainerTransform(thisWidget)
						return thisWidget.ChildContainer
					end,
					ChildDiscarded = function(thisWidget: Widget, _thisChild: Widget)
						UpdateChildContainerTransform(thisWidget)
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.isOpened == nil then
							thisWidget.state.isOpened = Iris._widgetState(thisWidget, "isOpened", false)
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local ChildContainer = thisWidget.ChildContainer :: ScrollingFrame
			
						if thisWidget.state.isOpened.value then
							thisWidget.lastOpenedTick = Iris._cycleTick + 1
							thisWidget.ButtonColors.ButtonTransparency = Iris._config.HeaderTransparency
							ChildContainer.Visible = true
			
							UpdateChildContainerTransform(thisWidget)
						else
							thisWidget.lastClosedTick = Iris._cycleTick + 1
							thisWidget.ButtonColors.ButtonTransparency = 1
							ChildContainer.Visible = false
						end
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("MenuItem", {
					hasState = false,
					hasChildren = false,
					Args = {
						Text = 1,
						KeyCode = 2,
						ModifierKey = 3,
					},
					Events = {
						["clicked"] = widgets.EVENTS.click(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local MenuItem: TextButton = Instance.new("TextButton")
						MenuItem.Name = "MenuItem"
						MenuItem.BackgroundTransparency = 1
						MenuItem.BorderSizePixel = 0
						MenuItem.Size = UDim2.fromScale(1, 0)
						MenuItem.Text = ""
						MenuItem.AutomaticSize = Enum.AutomaticSize.Y
						MenuItem.ZIndex = thisWidget.ZIndex
						MenuItem.LayoutOrder = thisWidget.ZIndex
						MenuItem.AutoButtonColor = false
			
						local UIPadding = widgets.UIPadding(MenuItem, Iris._config.FramePadding)
						UIPadding.PaddingTop = UIPadding.PaddingTop - UDim.new(0, 1)
						widgets.UIListLayout(MenuItem, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
						widgets.applyInteractionHighlights(thisWidget, MenuItem, MenuItem, {
							ButtonColor = Iris._config.HeaderColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.HeaderHoveredColor,
							ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
							ButtonActiveColor = Iris._config.HeaderHoveredColor,
							ButtonActiveTransparency = Iris._config.HeaderHoveredTransparency,
						})
			
						widgets.applyButtonClick(thisWidget, MenuItem, function()
							EmptyMenuStack()
						end)
			
						widgets.applyMouseEnter(thisWidget, MenuItem, function()
							local parentMenu: Widget = thisWidget.parentWidget
							if AnyMenuOpen and ActiveMenu and ActiveMenu ~= parentMenu then
								local parentIndex: number? = table.find(MenuStack, parentMenu)
			
								EmptyMenuStack(parentIndex)
								ActiveMenu = parentMenu
								AnyMenuOpen = true
							end
						end)
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						TextLabel.AnchorPoint = Vector2.new(0, 0)
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.ZIndex = thisWidget.ZIndex + 2
						TextLabel.LayoutOrder = thisWidget.ZIndex + 2
						TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			
						widgets.applyTextStyle(TextLabel)
			
						TextLabel.Parent = MenuItem
			
						local Shortcut: TextLabel = Instance.new("TextLabel")
						Shortcut.Name = "Shortcut"
						Shortcut.AnchorPoint = Vector2.new(0, 0)
						Shortcut.BackgroundTransparency = 1
						Shortcut.BorderSizePixel = 0
						Shortcut.ZIndex = thisWidget.ZIndex + 3
						Shortcut.LayoutOrder = thisWidget.ZIndex + 3
						Shortcut.AutomaticSize = Enum.AutomaticSize.XY
			
						widgets.applyTextStyle(Shortcut)
			
						Shortcut.Text = ""
						Shortcut.TextColor3 = Iris._config.TextDisabledColor
						Shortcut.TextTransparency = Iris._config.TextDisabledTransparency
			
						Shortcut.Parent = MenuItem
			
						return MenuItem
					end,
					Update = function(thisWidget: Widget)
						local MenuItem = thisWidget.Instance :: TextButton
						local TextLabel: TextLabel = MenuItem.TextLabel
						local Shortcut: TextLabel = MenuItem.Shortcut
			
						TextLabel.Text = thisWidget.arguments.Text
						if thisWidget.arguments.KeyCode then
							Shortcut.Text = thisWidget.arguments.ModifierKey.Name .. " + " .. thisWidget.arguments.KeyCode.Name
						end
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("MenuToggle", {
					hasState = true,
					hasChildren = false,
					Args = {
						Text = 1,
						KeyCode = 2,
						ModifierKey = 3,
					},
					Events = {
						["checked"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget): boolean
								return thisWidget.lastCheckedTick == Iris._cycleTick
							end,
						},
						["unchecked"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget): boolean
								return thisWidget.lastUncheckedTick == Iris._cycleTick
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local MenuItem: TextButton = Instance.new("TextButton")
						MenuItem.Name = "MenuItem"
						MenuItem.BackgroundTransparency = 1
						MenuItem.BorderSizePixel = 0
						MenuItem.Size = UDim2.fromScale(1, 0)
						MenuItem.Text = ""
						MenuItem.AutomaticSize = Enum.AutomaticSize.Y
						MenuItem.ZIndex = thisWidget.ZIndex
						MenuItem.LayoutOrder = thisWidget.ZIndex
						MenuItem.AutoButtonColor = false
			
						local UIPadding = widgets.UIPadding(MenuItem, Iris._config.FramePadding)
						UIPadding.PaddingTop = UIPadding.PaddingTop - UDim.new(0, 1)
						widgets.UIListLayout(MenuItem, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center
			
						widgets.applyInteractionHighlights(thisWidget, MenuItem, MenuItem, {
							ButtonColor = Iris._config.HeaderColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.HeaderHoveredColor,
							ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
							ButtonActiveColor = Iris._config.HeaderHoveredColor,
							ButtonActiveTransparency = Iris._config.HeaderHoveredTransparency,
						})
			
						widgets.applyButtonClick(thisWidget, MenuItem, function()
							local wasChecked: boolean = thisWidget.state.isChecked.value
							thisWidget.state.isChecked:set(not wasChecked)
							EmptyMenuStack()
						end)
			
						widgets.applyMouseEnter(thisWidget, MenuItem, function()
							local parentMenu: Widget = thisWidget.parentWidget
							if AnyMenuOpen and ActiveMenu and ActiveMenu ~= parentMenu then
								local parentIndex: number? = table.find(MenuStack, parentMenu)
			
								EmptyMenuStack(parentIndex)
								ActiveMenu = parentMenu
								AnyMenuOpen = true
							end
						end)
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						TextLabel.AnchorPoint = Vector2.new(0, 0)
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.ZIndex = thisWidget.ZIndex + 2
						TextLabel.LayoutOrder = thisWidget.ZIndex + 2
						TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			
						widgets.applyTextStyle(TextLabel)
			
						TextLabel.Parent = MenuItem
			
						local Shortcut: TextLabel = Instance.new("TextLabel")
						Shortcut.Name = "Shortcut"
						Shortcut.AnchorPoint = Vector2.new(0, 0)
						Shortcut.BackgroundTransparency = 1
						Shortcut.BorderSizePixel = 0
						Shortcut.ZIndex = thisWidget.ZIndex + 3
						Shortcut.LayoutOrder = thisWidget.ZIndex + 3
						Shortcut.AutomaticSize = Enum.AutomaticSize.XY
			
						widgets.applyTextStyle(Shortcut)
			
						Shortcut.Text = ""
						Shortcut.TextColor3 = Iris._config.TextDisabledColor
						Shortcut.TextTransparency = Iris._config.TextDisabledTransparency
			
						Shortcut.Parent = MenuItem
			
						local frameSize: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
						local padding: number = math.round(0.2 * frameSize)
						local iconSize: number = frameSize - 2 * padding
			
						local Icon: ImageLabel = Instance.new("ImageLabel")
						Icon.Name = "Icon"
						Icon.Size = UDim2.fromOffset(iconSize, iconSize)
						Icon.BackgroundTransparency = 1
						Icon.BorderSizePixel = 0
						Icon.ImageColor3 = Iris._config.TextColor
						Icon.ImageTransparency = Iris._config.TextTransparency
						Icon.Image = widgets.ICONS.CHECK_MARK
						Icon.ZIndex = thisWidget.ZIndex + 4
						Icon.LayoutOrder = thisWidget.ZIndex + 4
			
						Icon.Parent = MenuItem
			
						return MenuItem
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.isChecked == nil then
							thisWidget.state.isChecked = Iris._widgetState(thisWidget, "isChecked", false)
						end
					end,
					Update = function(thisWidget: Widget)
						local MenuItem = thisWidget.Instance :: TextButton
						local TextLabel: TextLabel = MenuItem.TextLabel
						local Shortcut: TextLabel = MenuItem.Shortcut
			
						TextLabel.Text = thisWidget.arguments.Text
						if thisWidget.arguments.KeyCode then
							Shortcut.Text = thisWidget.arguments.ModifierKey.Name .. " + " .. thisWidget.arguments.KeyCode.Name
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local MenuItem = thisWidget.Instance :: TextButton
						local Icon: ImageLabel = MenuItem.Icon
			
						if thisWidget.state.isChecked.value then
							Icon.Image = widgets.ICONS.CHECK_MARK
							thisWidget.lastCheckedTick = Iris._cycleTick + 1
						else
							Icon.Image = ""
							thisWidget.lastUncheckedTick = Iris._cycleTick + 1
						end
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
				} :: WidgetClass)
			end
		end)()

		local format = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				--stylua: ignore
				Iris.WidgetConstructor("Separator", {
					hasState = false,
					hasChildren = false,
					Args = {},
					Events = {},
					Generate = function(thisWidget: Widget): Frame
						local Separator: Frame = Instance.new("Frame")
						Separator.Name = "Iris_Separator"
						Separator.BackgroundColor3 = Iris._config.SeparatorColor
						Separator.BackgroundTransparency = Iris._config.SeparatorTransparency
						Separator.BorderSizePixel = 0
						if thisWidget.parentWidget.type == "SameLine" then
							Separator.Size = UDim2.new(0, 1, 1, 0)
						else
							Separator.Size = UDim2.new(1, 0, 0, 1)
						end
						Separator.ZIndex = thisWidget.ZIndex
						Separator.LayoutOrder = thisWidget.ZIndex
			
						widgets.UIListLayout(Separator, Enum.FillDirection.Vertical, UDim.new(0, 0))
						-- this is to prevent a bug of AutomaticLayout edge case when its parent has automaticLayout enabled
			
						return Separator
					end,
					Update = function(_thisWidget: Widget) end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("Indent", {
					hasState = false,
					hasChildren = true,
					Args = {
						["Width"] = 1,
					},
					Events = {},
					Generate = function(thisWidget: Widget): Frame
						local Indent: Frame = Instance.new("Frame")
						Indent.Name = "Iris_Indent"
						Indent.BackgroundTransparency = 1
						Indent.BorderSizePixel = 0
						Indent.Size = UDim2.fromScale(1, 0)
						Indent.AutomaticSize = Enum.AutomaticSize.Y
						Indent.ZIndex = thisWidget.ZIndex
						Indent.LayoutOrder = thisWidget.ZIndex
			
						widgets.UIListLayout(Indent, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
						widgets.UIPadding(Indent, Vector2.new(0, 0))
			
						return Indent
					end,
					Update = function(thisWidget: Widget)
						local Indent = thisWidget.Instance :: Frame
			
						local indentWidth: number
						if thisWidget.arguments.Width then
							indentWidth = thisWidget.arguments.Width
						else
							indentWidth = Iris._config.IndentSpacing
						end
						Indent.UIPadding.PaddingLeft = UDim.new(0, indentWidth)
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
					ChildAdded = function(thisWidget: Widget, _thisChild: Widget)
						return thisWidget.Instance
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("SameLine", {
					hasState = false,
					hasChildren = true,
					Args = {
						["Width"] = 1,
						["VerticalAlignment"] = 2,
					},
					Events = {},
					Generate = function(thisWidget: Widget): Frame
						local SameLine: Frame = Instance.new("Frame")
						SameLine.Name = "Iris_SameLine"
						SameLine.BackgroundTransparency = 1
						SameLine.BorderSizePixel = 0
						SameLine.Size = UDim2.fromScale(1, 0)
						SameLine.AutomaticSize = Enum.AutomaticSize.Y
						SameLine.ZIndex = thisWidget.ZIndex
						SameLine.LayoutOrder = thisWidget.ZIndex
			
						widgets.UIListLayout(SameLine, Enum.FillDirection.Horizontal, UDim.new(0, 0))
			
						return SameLine
					end,
					Update = function(thisWidget: Widget)
						local Sameline = thisWidget.Instance :: Frame
						local uiListLayout: UIListLayout = Sameline.UIListLayout
						local itemWidth: number
						if thisWidget.arguments.Width then
							itemWidth = thisWidget.arguments.Width
						else
							itemWidth = Iris._config.ItemSpacing.X
						end
						uiListLayout.Padding = UDim.new(0, itemWidth)
						if thisWidget.arguments.VerticalAlignment then
							uiListLayout.VerticalAlignment = thisWidget.arguments.VerticalAlignment
						else
							uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						end
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
					ChildAdded = function(thisWidget: Widget, _thisChild: Widget)
						return thisWidget.Instance
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("Group", {
					hasState = false,
					hasChildren = true,
					Args = {},
					Events = {},
					Generate = function(thisWidget: Widget): Frame
						local Group: Frame = Instance.new("Frame")
						Group.Name = "Iris_Group"
						Group.BackgroundTransparency = 1
						Group.BorderSizePixel = 0
						Group.Size = UDim2.fromOffset(0, 0)
						Group.AutomaticSize = Enum.AutomaticSize.XY
						Group.ZIndex = thisWidget.ZIndex
						Group.LayoutOrder = thisWidget.ZIndex
						Group.ClipsDescendants = true
			
						widgets.UIListLayout(Group, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.X))
			
						return Group
					end,
					Update = function(_thisWidget: Widget) end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
					ChildAdded = function(thisWidget: Widget, _thisChild: Widget)
						return thisWidget.Instance
					end,
				} :: WidgetClass)
			end
		end)()

		local text = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				--stylua: ignore
				Iris.WidgetConstructor("Text", {
					hasState = false,
					hasChildren = false,
					Args = {
						["Text"] = 1,
						["Wrapped"] = 2,
						["Color"] = 3,
						["RichText"] = 4,
					},
					Events = {
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local Text: TextLabel = Instance.new("TextLabel")
						Text.Name = "Iris_Text"
						Text.Size = UDim2.fromOffset(0, 0)
						Text.BackgroundTransparency = 1
						Text.BorderSizePixel = 0
						Text.ZIndex = thisWidget.ZIndex
						Text.LayoutOrder = thisWidget.ZIndex
						Text.AutomaticSize = Enum.AutomaticSize.XY
			
						widgets.applyTextStyle(Text)
						widgets.UIPadding(Text, Vector2.new(0, 2))
			
						return Text
					end,
					Update = function(thisWidget: Widget)
						local Text = thisWidget.Instance :: TextLabel
						if thisWidget.arguments.Text == nil then
							error("Iris.Text Text Argument is required", 5)
						end
						if thisWidget.arguments.Wrapped ~= nil then
							Text.TextWrapped = thisWidget.arguments.Wrapped
						else
							Text.TextWrapped = Iris._config.TextWrapped
						end
						if thisWidget.arguments.Color then
							Text.TextColor3 = thisWidget.arguments.Color
						else
							Text.TextColor3 = Iris._config.TextColor
						end
						if thisWidget.arguments.RichText ~= nil then
							Text.RichText = thisWidget.arguments.RichText
						else
							Text.RichText = Iris._config.RichText
						end
			
						Text.Text = thisWidget.arguments.Text
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			
				--stylua: ignore
				Iris.WidgetConstructor("SeparatorText", {
					hasState = false,
					hasChildren = false,
					Args = {
						["Text"] = 1,
					},
					Events = {
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local SeparatorText = Instance.new("Frame")
						SeparatorText.Name = "Iris_SeparatorText"
						SeparatorText.Size = UDim2.fromScale(1, 0)
						SeparatorText.BackgroundTransparency = 1
						SeparatorText.BorderSizePixel = 0
						SeparatorText.AutomaticSize = Enum.AutomaticSize.Y
						SeparatorText.ZIndex = thisWidget.ZIndex
						SeparatorText.LayoutOrder = thisWidget.ZIndex
						SeparatorText.ClipsDescendants = true
			
						widgets.UIPadding(SeparatorText, Vector2.new(0, Iris._config.SeparatorTextPadding.Y))
						widgets.UIListLayout(SeparatorText, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemSpacing.X))
			
						SeparatorText.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.AutomaticSize = Enum.AutomaticSize.XY
						TextLabel.ZIndex = thisWidget.ZIndex + 1
						TextLabel.LayoutOrder = thisWidget.ZIndex + 1
			
						widgets.applyTextStyle(TextLabel)
			
						TextLabel.Parent = SeparatorText
			
						local Left: Frame = Instance.new("Frame")
						Left.Name = "Left"
						Left.AnchorPoint = Vector2.new(1, 0.5)
						Left.BackgroundColor3 = Iris._config.SeparatorColor
						Left.BackgroundTransparency = Iris._config.SeparatorTransparency
						Left.BorderSizePixel = 0
						Left.Size = UDim2.fromOffset(Iris._config.SeparatorTextPadding.X - Iris._config.ItemSpacing.X, Iris._config.SeparatorTextBorderSize)
						Left.ZIndex = thisWidget.ZIndex
						Left.LayoutOrder = thisWidget.ZIndex
			
						Left.Parent = SeparatorText
			
						local Right: Frame = Instance.new("Frame")
						Right.Name = "Right"
						Right.AnchorPoint = Vector2.new(1, 0.5)
						Right.BackgroundColor3 = Iris._config.SeparatorColor
						Right.BackgroundTransparency = Iris._config.SeparatorTransparency
						Right.BorderSizePixel = 0
						Right.Size = UDim2.new(1, 0, 0, Iris._config.SeparatorTextBorderSize)
						Right.ZIndex = thisWidget.ZIndex + 2
						Right.LayoutOrder = thisWidget.ZIndex + 2
			
						Right.Parent = SeparatorText
			
						return SeparatorText
					end,
					Update = function(thisWidget: Widget)
						local SeparatorText = thisWidget.Instance :: Frame
						local TextLabel: TextLabel = SeparatorText.TextLabel
						if thisWidget.arguments.Text == nil then
							error("Iris.Text Text Argument is required", 5)
						end
						TextLabel.Text = thisWidget.arguments.Text
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass)
			end
		end)()
		local button = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local abstractButton = {
					hasState = false,
					hasChildren = false,
					Args = {
						["Text"] = 1,
					},
					Events = {
						["clicked"] = widgets.EVENTS.click(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["rightClicked"] = widgets.EVENTS.rightClick(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["doubleClicked"] = widgets.EVENTS.doubleClick(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["ctrlClicked"] = widgets.EVENTS.ctrlClick(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget): TextButton
						local Button: TextButton = Instance.new("TextButton")
						Button.Size = UDim2.fromOffset(0, 0)
						Button.BackgroundColor3 = Iris._config.ButtonColor
						Button.BackgroundTransparency = Iris._config.ButtonTransparency
						Button.AutoButtonColor = false

						widgets.applyTextStyle(Button)
						Button.AutomaticSize = Enum.AutomaticSize.XY

						widgets.applyFrameStyle(Button)

						widgets.applyInteractionHighlights(thisWidget, Button, Button, {
							ButtonColor = Iris._config.ButtonColor,
							ButtonTransparency = Iris._config.ButtonTransparency,
							ButtonHoveredColor = Iris._config.ButtonHoveredColor,
							ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
							ButtonActiveColor = Iris._config.ButtonActiveColor,
							ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
						})

						Button.ZIndex = thisWidget.ZIndex
						Button.LayoutOrder = thisWidget.ZIndex

						return Button
					end,
					Update = function(thisWidget: Widget)
						local Button = thisWidget.Instance :: TextButton
						Button.Text = thisWidget.arguments.Text or "Button"
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
					end,
				} :: WidgetClass
				widgets.abstractButton = abstractButton

				--stylua: ignore
				Iris.WidgetConstructor("Button", widgets.extend(abstractButton, {
						Generate = function(thisWidget: Widget): TextButton
							local Button: TextButton = abstractButton.Generate(thisWidget)
							Button.Name = "Iris_Button"

							return Button
						end,
					} :: WidgetClass)
				)

				--stylua: ignore
				Iris.WidgetConstructor("SmallButton", widgets.extend(abstractButton, {
						Generate = function(thisWidget: Widget): TextButton
							local SmallButton = abstractButton.Generate(thisWidget) :: TextButton
							SmallButton.Name = "Iris_SmallButton"

							local uiPadding: UIPadding = SmallButton.UIPadding
							uiPadding.PaddingLeft = UDim.new(0, 2)
							uiPadding.PaddingRight = UDim.new(0, 2)
							uiPadding.PaddingTop = UDim.new(0, 0)
							uiPadding.PaddingBottom = UDim.new(0, 0)

							return SmallButton
						end,
					} :: WidgetClass)
				)
			end
		end)()
		local checkbox = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				--stylua: ignore
				Iris.WidgetConstructor("Checkbox", {
					hasState = true,
					hasChildren = false,
					Args = {
						["Text"] = 1,
					},
					Events = {
						["checked"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget): boolean
								return thisWidget.lastCheckedTick == Iris._cycleTick
							end,
						},
						["unchecked"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget): boolean
								return thisWidget.lastUncheckedTick == Iris._cycleTick
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget): GuiObject
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget): TextButton
						local Checkbox: TextButton = Instance.new("TextButton")
						Checkbox.Name = "Iris_Checkbox"
						Checkbox.BackgroundTransparency = 1
						Checkbox.BorderSizePixel = 0
						Checkbox.Size = UDim2.fromOffset(0, 0)
						Checkbox.Text = ""
						Checkbox.AutomaticSize = Enum.AutomaticSize.XY
						Checkbox.ZIndex = thisWidget.ZIndex
						Checkbox.AutoButtonColor = false
						Checkbox.LayoutOrder = thisWidget.ZIndex
			
						local checkboxSize: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
			
						local CheckboxBox: Frame = Instance.new("Frame")
						CheckboxBox.Name = "CheckboxBox"
						CheckboxBox.Size = UDim2.fromOffset(checkboxSize, checkboxSize)
						CheckboxBox.BackgroundColor3 = Iris._config.FrameBgColor
						CheckboxBox.BackgroundTransparency = Iris._config.FrameBgTransparency
						CheckboxBox.ZIndex = thisWidget.ZIndex + 1
						CheckboxBox.LayoutOrder = thisWidget.ZIndex + 1
						widgets.applyFrameStyle(CheckboxBox, true)
			
						widgets.applyInteractionHighlights(thisWidget, Checkbox, CheckboxBox, {
							ButtonColor = Iris._config.FrameBgColor,
							ButtonTransparency = Iris._config.FrameBgTransparency,
							ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
							ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
							ButtonActiveColor = Iris._config.FrameBgActiveColor,
							ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
						})
			
						CheckboxBox.Parent = Checkbox
			
						local padding: number = math.ceil(checkboxSize * 0.1)
						local checkmarkSize: number = checkboxSize - 2 * padding
			
						local Checkmark: ImageLabel = Instance.new("ImageLabel")
						Checkmark.Name = "Checkmark"
						Checkmark.Size = UDim2.fromOffset(checkmarkSize, checkmarkSize)
						Checkmark.Position = UDim2.fromOffset(padding, padding)
						Checkmark.BackgroundTransparency = 1
						Checkmark.ImageColor3 = Iris._config.CheckMarkColor
						Checkmark.ImageTransparency = Iris._config.CheckMarkTransparency
						Checkmark.ScaleType = Enum.ScaleType.Fit
						Checkmark.ZIndex = thisWidget.ZIndex + 2
						Checkmark.LayoutOrder = thisWidget.ZIndex + 2
			
						Checkmark.Parent = Checkbox
			
						widgets.applyButtonClick(thisWidget, Checkbox, function()
							local wasChecked: boolean = thisWidget.state.isChecked.value
							thisWidget.state.isChecked:set(not wasChecked)
						end)
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						widgets.applyTextStyle(TextLabel)
						TextLabel.AnchorPoint = Vector2.new(0, 0.5)
						TextLabel.Position = UDim2.new(0, checkboxSize + Iris._config.ItemInnerSpacing.X, 0.5, 0)
						TextLabel.ZIndex = thisWidget.ZIndex + 1
						TextLabel.LayoutOrder = thisWidget.ZIndex + 1
						TextLabel.AutomaticSize = Enum.AutomaticSize.XY
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.Parent = Checkbox
			
						return Checkbox
					end,
					Update = function(thisWidget: Widget)
						local Checkbox = thisWidget.Instance :: TextButton
						Checkbox.TextLabel.Text = thisWidget.arguments.Text or "Checkbox"
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.isChecked == nil then
							thisWidget.state.isChecked = Iris._widgetState(thisWidget, "checked", false)
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local Checkbox = thisWidget.Instance :: TextButton
						local Checkmark: ImageLabel = Checkbox.Checkmark
						if thisWidget.state.isChecked.value then
							Checkmark.Image = widgets.ICONS.CHECK_MARK
							thisWidget.lastCheckedTick = Iris._cycleTick + 1
						else
							Checkmark.Image = ""
							thisWidget.lastUncheckedTick = Iris._cycleTick + 1
						end
					end,
				} :: WidgetClass)
			end
		end)()
		local radioButton = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				--stylua: ignore
				Iris.WidgetConstructor("RadioButton", {
					hasState = true,
					hasChildren = false,
					Args = {
						["Text"] = 1,
						["Index"] = 2,
					},
					Events = {
						["selected"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastSelectedTick == Iris._cycleTick
							end,
						},
						["unselected"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastUnselectedTick == Iris._cycleTick
							end,
						},
						["active"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.state.index.value == thisWidget.arguments.Index
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local RadioButton: TextButton = Instance.new("TextButton")
						RadioButton.Name = "Iris_RadioButton"
						RadioButton.BackgroundTransparency = 1
						RadioButton.BorderSizePixel = 0
						RadioButton.Size = UDim2.fromOffset(0, 0)
						RadioButton.Text = ""
						RadioButton.AutomaticSize = Enum.AutomaticSize.XY
						RadioButton.ZIndex = thisWidget.ZIndex
						RadioButton.AutoButtonColor = false
						RadioButton.LayoutOrder = thisWidget.ZIndex
			
						local buttonSize: number = Iris._config.TextSize + 2 * (Iris._config.FramePadding.Y - 1)
						local Button: Frame = Instance.new("Frame")
						Button.Name = "Button"
						Button.Size = UDim2.fromOffset(buttonSize, buttonSize)
						Button.ZIndex = thisWidget.ZIndex + 1
						Button.LayoutOrder = thisWidget.ZIndex + 1
						Button.Parent = RadioButton
						Button.BackgroundColor3 = Iris._config.FrameBgColor
						Button.BackgroundTransparency = Iris._config.FrameBgTransparency
			
						widgets.UICorner(Button)
			
						local Circle: Frame = Instance.new("Frame")
						Circle.Name = "Circle"
						Circle.Position = UDim2.fromOffset(Iris._config.FramePadding.Y, Iris._config.FramePadding.Y)
						Circle.Size = UDim2.fromOffset(Iris._config.TextSize - 2, Iris._config.TextSize - 2)
						Circle.ZIndex = thisWidget.ZIndex + 1
						Circle.LayoutOrder = thisWidget.ZIndex + 1
						Circle.Parent = Button
						Circle.BackgroundColor3 = Iris._config.CheckMarkColor
						Circle.BackgroundTransparency = Iris._config.CheckMarkTransparency
						widgets.UICorner(Circle)
			
						widgets.applyInteractionHighlights(thisWidget, RadioButton, Button, {
							ButtonColor = Iris._config.FrameBgColor,
							ButtonTransparency = Iris._config.FrameBgTransparency,
							ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
							ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
							ButtonActiveColor = Iris._config.FrameBgActiveColor,
							ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
						})
			
						widgets.applyButtonClick(thisWidget, RadioButton, function()
							thisWidget.state.index:set(thisWidget.arguments.Index)
						end)
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						widgets.applyTextStyle(TextLabel)
						TextLabel.Position = UDim2.new(0, buttonSize + Iris._config.ItemInnerSpacing.X, 0.5, 0)
						TextLabel.ZIndex = thisWidget.ZIndex + 1
						TextLabel.LayoutOrder = thisWidget.ZIndex + 1
						TextLabel.AutomaticSize = Enum.AutomaticSize.XY
						TextLabel.AnchorPoint = Vector2.new(0, 0.5)
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.Parent = RadioButton
			
						return RadioButton
					end,
					Update = function(thisWidget: Widget)
						local RadioButton = thisWidget.Instance :: TextButton
						local TextLabel: TextLabel = RadioButton.TextLabel
			
						TextLabel.Text = thisWidget.arguments.Text or "Radio Button"
						if thisWidget.state then
							Iris._widgets[thisWidget.type].UpdateState(thisWidget)
						end
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.index == nil then
							thisWidget.state.index = Iris._widgetState(thisWidget, "index", thisWidget.arguments.Value)
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local RadioButton = thisWidget.Instance :: TextButton
						local Button = RadioButton.Button :: Frame
						local Circle: Frame = Button.Circle
			
						if thisWidget.state.index.value == thisWidget.arguments.Index then
							-- only need to hide the circle
							Circle.BackgroundTransparency = Iris._config.CheckMarkTransparency
							thisWidget.lastSelectedTick = Iris._cycleTick + 1
						else
							Circle.BackgroundTransparency = 1
							thisWidget.lastUnselectedTick = Iris._cycleTick + 1
						end
					end,
				} :: WidgetClass)
			end
		end)()
		local tree = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local abstractTree = {
					hasState = true,
					hasChildren = true,
					Events = {
						["collapsed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastCollapsedTick == Iris._cycleTick
							end,
						},
						["uncollapsed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastUncollapsedTick == Iris._cycleTick
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget)
							return thisWidget.Instance
						end),
					},
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					ChildAdded = function(thisWidget: Widget)
						local Tree = thisWidget.Instance :: Frame
						local ChildContainer: Frame = Tree.ChildContainer
			
						ChildContainer.Visible = thisWidget.state.isUncollapsed.value
			
						return ChildContainer
					end,
					UpdateState = function(thisWidget: Widget)
						local isUncollapsed: boolean = thisWidget.state.isUncollapsed.value
						local Tree = thisWidget.Instance :: Frame
						local ChildContainer: Frame = Tree.ChildContainer
						local Header = Tree.Header :: Frame
						local Button = Header.Button :: TextButton
						local Arrow: ImageLabel = Button.Arrow
			
						Arrow.Image = (isUncollapsed and widgets.ICONS.DOWN_POINTING_TRIANGLE or widgets.ICONS.RIGHT_POINTING_TRIANGLE)
						if isUncollapsed then
							thisWidget.lastUncollapsedTick = Iris._cycleTick + 1
						else
							thisWidget.lastCollapsedTick = Iris._cycleTick + 1
						end
			
						ChildContainer.Visible = isUncollapsed
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.isUncollapsed == nil then
							thisWidget.state.isUncollapsed = Iris._widgetState(thisWidget, "isUncollapsed", false)
						end
					end,
				} :: WidgetClass
			
				--stylua: ignore
				Iris.WidgetConstructor(
					"Tree",
					widgets.extend(abstractTree, {
						Args = {
							["Text"] = 1,
							["SpanAvailWidth"] = 2,
							["NoIndent"] = 3,
						},
						Generate = function(thisWidget: Widget)
							local Tree: Frame = Instance.new("Frame")
							Tree.Name = "Iris_Tree"
							Tree.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
							Tree.AutomaticSize = Enum.AutomaticSize.Y
							Tree.BackgroundTransparency = 1
							Tree.BorderSizePixel = 0
							Tree.ZIndex = thisWidget.ZIndex
							Tree.LayoutOrder = thisWidget.ZIndex
			
							widgets.UIListLayout(Tree, Enum.FillDirection.Vertical, UDim.new(0, 0))
			
							local ChildContainer: Frame = Instance.new("Frame")
							ChildContainer.Name = "ChildContainer"
							ChildContainer.Size = UDim2.fromScale(1, 0)
							ChildContainer.AutomaticSize = Enum.AutomaticSize.Y
							ChildContainer.BackgroundTransparency = 1
							ChildContainer.BorderSizePixel = 0
							ChildContainer.ZIndex = thisWidget.ZIndex + 1
							ChildContainer.LayoutOrder = thisWidget.ZIndex + 1
							ChildContainer.Visible = false
							-- ChildContainer.ClipsDescendants = true
			
							widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
							local ChildContainerPadding: UIPadding = widgets.UIPadding(ChildContainer, Vector2.new(0, 0))
							ChildContainerPadding.PaddingTop = UDim.new(0, Iris._config.ItemSpacing.Y)
			
							ChildContainer.Parent = Tree
			
							local Header: Frame = Instance.new("Frame")
							Header.Name = "Header"
							Header.Size = UDim2.fromScale(1, 0)
							Header.AutomaticSize = Enum.AutomaticSize.Y
							Header.BackgroundTransparency = 1
							Header.BorderSizePixel = 0
							Header.ZIndex = thisWidget.ZIndex
							Header.LayoutOrder = thisWidget.ZIndex
							Header.Parent = Tree
			
							local Button: TextButton = Instance.new("TextButton")
							Button.Name = "Button"
							Button.BackgroundTransparency = 1
							Button.BorderSizePixel = 0
							Button.Text = ""
							Button.ZIndex = thisWidget.ZIndex
							Button.LayoutOrder = thisWidget.ZIndex
							Button.AutoButtonColor = false
			
							widgets.applyInteractionHighlights(thisWidget, Button, Header, {
								ButtonColor = Color3.fromRGB(0, 0, 0),
								ButtonTransparency = 1,
								ButtonHoveredColor = Iris._config.HeaderHoveredColor,
								ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
								ButtonActiveColor = Iris._config.HeaderActiveColor,
								ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
							})
			
							local ButtonPadding: UIPadding = widgets.UIPadding(Button, Vector2.zero)
							ButtonPadding.PaddingLeft = UDim.new(0, Iris._config.FramePadding.X)
							local ButtonUIListLayout: UIListLayout = widgets.UIListLayout(Button, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.FramePadding.X))
							ButtonUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			
							Button.Parent = Header
			
							local Arrow: ImageLabel = Instance.new("ImageLabel")
							Arrow.Name = "Arrow"
							Arrow.Size = UDim2.fromOffset(Iris._config.TextSize, math.floor(Iris._config.TextSize * 0.7))
							Arrow.BackgroundTransparency = 1
							Arrow.BorderSizePixel = 0
							Arrow.ImageColor3 = Iris._config.TextColor
							Arrow.ImageTransparency = Iris._config.TextTransparency
							Arrow.ScaleType = Enum.ScaleType.Fit
							Arrow.ZIndex = thisWidget.ZIndex
							Arrow.LayoutOrder = thisWidget.ZIndex
			
							Arrow.Parent = Button
			
							local TextLabel: TextLabel = Instance.new("TextLabel")
							TextLabel.Name = "TextLabel"
							TextLabel.Size = UDim2.fromOffset(0, 0)
							TextLabel.AutomaticSize = Enum.AutomaticSize.XY
							TextLabel.BackgroundTransparency = 1
							TextLabel.BorderSizePixel = 0
							TextLabel.ZIndex = thisWidget.ZIndex
							TextLabel.LayoutOrder = thisWidget.ZIndex
			
							local TextPadding: UIPadding = widgets.UIPadding(TextLabel, Vector2.new(0, 0))
							TextPadding.PaddingRight = UDim.new(0, 21)
							widgets.applyTextStyle(TextLabel)
			
							TextLabel.Parent = Button
			
							widgets.applyButtonClick(thisWidget, Button, function()
								thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
							end)
			
							return Tree
						end,
						Update = function(thisWidget: Widget)
							local Tree = thisWidget.Instance :: Frame
							local Header = Tree.Header :: Frame
							local Button = Header.Button :: TextButton
							local TextLabel: TextLabel = Button.TextLabel
							local ChildContainer = Tree.ChildContainer :: Frame
							local Padding: UIPadding = ChildContainer.UIPadding
			
							TextLabel.Text = thisWidget.arguments.Text or "Tree"
							if thisWidget.arguments.SpanAvailWidth then
								Button.AutomaticSize = Enum.AutomaticSize.Y
								Button.Size = UDim2.fromScale(1, 0)
							else
								Button.AutomaticSize = Enum.AutomaticSize.XY
								Button.Size = UDim2.fromScale(0, 0)
							end
			
							if thisWidget.arguments.NoIndent then
								Padding.PaddingLeft = UDim.new(0, 0)
							else
								Padding.PaddingLeft = UDim.new(0, Iris._config.IndentSpacing)
							end
						end,
					})
				)
			
				--stylua: ignore
				Iris.WidgetConstructor(
					"CollapsingHeader",
					widgets.extend(abstractTree, {
						Args = {
							["Text"] = 1,
						},
						Generate = function(thisWidget: Widget)
							local CollapsingHeader: Frame = Instance.new("Frame")
							CollapsingHeader.Name = "Iris_CollapsingHeader"
							CollapsingHeader.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
							CollapsingHeader.AutomaticSize = Enum.AutomaticSize.Y
							CollapsingHeader.BackgroundTransparency = 1
							CollapsingHeader.BorderSizePixel = 0
							CollapsingHeader.ZIndex = thisWidget.ZIndex
							CollapsingHeader.LayoutOrder = thisWidget.ZIndex
			
							widgets.UIListLayout(CollapsingHeader, Enum.FillDirection.Vertical, UDim.new(0, 0))
			
							local ChildContainer: Frame = Instance.new("Frame")
							ChildContainer.Name = "ChildContainer"
							ChildContainer.Size = UDim2.fromScale(1, 0)
							ChildContainer.AutomaticSize = Enum.AutomaticSize.Y
							ChildContainer.BackgroundTransparency = 1
							ChildContainer.BorderSizePixel = 0
							ChildContainer.ZIndex = thisWidget.ZIndex + 1
							ChildContainer.LayoutOrder = thisWidget.ZIndex + 1
							ChildContainer.Visible = false
							-- ChildContainer.ClipsDescendants = true
			
							widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
							local ChildContainerPadding: UIPadding = widgets.UIPadding(ChildContainer, Vector2.new(0, 0))
							ChildContainerPadding.PaddingTop = UDim.new(0, Iris._config.ItemSpacing.Y)
			
							ChildContainer.Parent = CollapsingHeader
			
							local Header: Frame = Instance.new("Frame")
							Header.Name = "Header"
							Header.Size = UDim2.fromScale(1, 0)
							Header.AutomaticSize = Enum.AutomaticSize.Y
							Header.BackgroundTransparency = 1
							Header.BorderSizePixel = 0
							Header.ZIndex = thisWidget.ZIndex
							Header.LayoutOrder = thisWidget.ZIndex
							Header.Parent = CollapsingHeader
			
							local Button = Instance.new("TextButton")
							Button.Name = "Button"
							Button.Size = UDim2.new(1, 2 * Iris._config.FramePadding.X, 0, 0)
							Button.Position = UDim2.fromOffset(-4, 0)
							Button.AutomaticSize = Enum.AutomaticSize.Y
							Button.BackgroundColor3 = Iris._config.HeaderColor
							Button.BackgroundTransparency = Iris._config.HeaderTransparency
							Button.BorderSizePixel = 0
							Button.Text = ""
							Button.ZIndex = thisWidget.ZIndex
							Button.LayoutOrder = thisWidget.ZIndex
							Button.AutoButtonColor = false
							Button.ClipsDescendants = true
			
							widgets.UIPadding(Button, Vector2.new(2 * Iris._config.FramePadding.X, Iris._config.FramePadding.Y)) -- we add a custom padding because it extends on both sides
							widgets.applyFrameStyle(Button, true, true)
							local ButtonUIListLayout: UIListLayout = widgets.UIListLayout(Button, Enum.FillDirection.Horizontal, UDim.new(0, 2 * Iris._config.FramePadding.X))
							ButtonUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			
							widgets.applyInteractionHighlights(thisWidget, Button, Button, {
								ButtonColor = Iris._config.HeaderColor,
								ButtonTransparency = Iris._config.HeaderTransparency,
								ButtonHoveredColor = Iris._config.HeaderHoveredColor,
								ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
								ButtonActiveColor = Iris._config.HeaderActiveColor,
								ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
							})
			
							Button.Parent = Header
			
							local Arrow: ImageLabel = Instance.new("ImageLabel")
							Arrow.Name = "Arrow"
							Arrow.Size = UDim2.fromOffset(Iris._config.TextSize, math.ceil(Iris._config.TextSize * 0.8))
							Arrow.AutomaticSize = Enum.AutomaticSize.Y
							Arrow.BackgroundTransparency = 1
							Arrow.BorderSizePixel = 0
							Arrow.ImageColor3 = Iris._config.TextColor
							Arrow.ImageTransparency = Iris._config.TextTransparency
							Arrow.ScaleType = Enum.ScaleType.Fit
							Arrow.ZIndex = thisWidget.ZIndex
							Arrow.LayoutOrder = thisWidget.ZIndex
			
							Arrow.Parent = Button
			
							local TextLabel: TextLabel = Instance.new("TextLabel")
							TextLabel.Name = "TextLabel"
							TextLabel.Size = UDim2.fromOffset(0, 0)
							TextLabel.AutomaticSize = Enum.AutomaticSize.XY
							TextLabel.BackgroundTransparency = 1
							TextLabel.BorderSizePixel = 0
							TextLabel.ZIndex = thisWidget.ZIndex
							TextLabel.LayoutOrder = thisWidget.ZIndex
			
							local TextPadding: UIPadding = widgets.UIPadding(TextLabel, Vector2.new(0, 0))
							TextPadding.PaddingRight = UDim.new(0, 21)
							widgets.applyTextStyle(TextLabel)
			
							TextLabel.Parent = Button
			
							widgets.applyButtonClick(thisWidget, Button, function()
								thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
							end)
			
							return CollapsingHeader
						end,
						Update = function(thisWidget: Widget)
							local Tree = thisWidget.Instance :: Frame
							local Header = Tree.Header :: Frame
							local Button = Header.Button :: TextButton
							local TextLabel: TextLabel = Button.TextLabel
			
							TextLabel.Text = thisWidget.arguments.Text or "Collapsing Header"
						end,
					})
				)
			end
		end)()

		local input = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local numberChanged = {
					["Init"] = function(_thisWidget: Widget) end,
					["Get"] = function(thisWidget: Widget)
						return thisWidget.lastNumberChangedTick == Iris._cycleTick
					end,
				}
			
				local function getValueByIndex(value: InputDataType, index: number, arguments: Arguments): number
					if typeof(value) == "number" then
						return value
					elseif typeof(value) == "Vector2" then
						if index == 1 then
							return value.X
						elseif index == 2 then
							return value.Y
						end
					elseif typeof(value) == "Vector3" then
						if index == 1 then
							return value.X
						elseif index == 2 then
							return value.Y
						elseif index == 3 then
							return value.Z
						end
					elseif typeof(value) == "UDim" then
						if index == 1 then
							return value.Scale
						elseif index == 2 then
							return value.Offset
						end
					elseif typeof(value) == "UDim2" then
						if index == 1 then
							return value.X.Scale
						elseif index == 2 then
							return value.X.Offset
						elseif index == 3 then
							return value.Y.Scale
						elseif index == 4 then
							return value.Y.Offset
						end
					elseif typeof(value) == "Color3" then
						local color: { number } = arguments.UseHSV and { value:ToHSV() } or { value.R, value.G, value.B }
						if index == 1 then
							return color[1]
						elseif index == 2 then
							return color[2]
						elseif index == 3 then
							return color[3]
						end
					elseif typeof(value) == "Rect" then
						if index == 1 then
							return value.Min.X
						elseif index == 2 then
							return value.Min.Y
						elseif index == 3 then
							return value.Max.X
						elseif index == 4 then
							return value.Max.Y
						end
					elseif typeof(value) == "table" then
						return value[index]
					end
			
					error(`Incorrect datatype or value: {value} {typeof(value)} {index}`)
				end
			
				local function updateValueByIndex(value: InputDataType, index: number, newValue: number, arguments: Arguments): InputDataType
					if typeof(value) == "number" then
						return newValue
					elseif typeof(value) == "Vector2" then
						if index == 1 then
							return Vector2.new(newValue, value.Y)
						elseif index == 2 then
							return Vector2.new(value.X, newValue)
						end
					elseif typeof(value) == "Vector3" then
						if index == 1 then
							return Vector3.new(newValue, value.Y, value.Z)
						elseif index == 2 then
							return Vector3.new(value.X, newValue, value.Z)
						elseif index == 3 then
							return Vector3.new(value.X, value.Y, newValue)
						end
					elseif typeof(value) == "UDim" then
						if index == 1 then
							return UDim.new(newValue, value.Offset)
						elseif index == 2 then
							return UDim.new(value.Scale, newValue)
						end
					elseif typeof(value) == "UDim2" then
						if index == 1 then
							return UDim2.new(UDim.new(newValue, value.X.Offset), value.Y)
						elseif index == 2 then
							return UDim2.new(UDim.new(value.X.Scale, newValue), value.Y)
						elseif index == 3 then
							return UDim2.new(value.X, UDim.new(newValue, value.Y.Offset))
						elseif index == 4 then
							return UDim2.new(value.X, UDim.new(value.Y.Scale, newValue))
						end
					elseif typeof(value) == "Rect" then
						if index == 1 then
							return Rect.new(Vector2.new(newValue, value.Min.Y), value.Max)
						elseif index == 2 then
							return Rect.new(Vector2.new(value.Min.X, newValue), value.Max)
						elseif index == 3 then
							return Rect.new(value.Min, Vector2.new(newValue, value.Max.Y))
						elseif index == 4 then
							return Rect.new(value.Min, Vector2.new(value.Max.X, newValue))
						end
					elseif typeof(value) == "Color3" then
						if arguments.UseHSV then
							local h: number, s: number, v: number = value:ToHSV()
							if index == 1 then
								return Color3.fromHSV(newValue, s, v)
							elseif index == 2 then
								return Color3.fromHSV(h, newValue, v)
							elseif index == 3 then
								return Color3.fromHSV(h, s, newValue)
							end
						end
						if index == 1 then
							return Color3.new(newValue, value.G, value.B)
						elseif index == 2 then
							return Color3.new(value.R, newValue, value.B)
						elseif index == 3 then
							return Color3.new(value.R, value.G, newValue)
						end
					end
			
					error(`Incorrect datatype or value {value} {typeof(value)} {index}`)
				end
			
				local defaultIncrements: { [InputDataTypes]: { number } } = {
					Num = { 1 },
					Vector2 = { 1, 1 },
					Vector3 = { 1, 1, 1 },
					UDim = { 0.01, 1 },
					UDim2 = { 0.01, 1, 0.01, 1 },
					Color3 = { 1, 1, 1 },
					Color4 = { 1, 1, 1, 1 },
					Rect = { 1, 1, 1, 1 },
				}
			
				local defaultMin: { [InputDataTypes]: { number } } = {
					Num = { 0 },
					Vector2 = { 0, 0 },
					Vector3 = { 0, 0, 0 },
					UDim = { 0, 0 },
					UDim2 = { 0, 0, 0, 0 },
					Rect = { 0, 0, 0, 0 },
				}
			
				local defaultMax: { [InputDataTypes]: { number } } = {
					Num = { 100 },
					Vector2 = { 100, 100 },
					Vector3 = { 100, 100, 100 },
					UDim = { 1, 960 },
					UDim2 = { 1, 960, 1, 960 },
					Rect = { 960, 960, 960, 960 },
				}
			
				local defaultPrefx: { [InputDataTypes]: { string } } = {
					Num = { "" },
					Vector2 = { "X: ", "Y: " },
					Vector3 = { "X: ", "Y: ", "Z: " },
					UDim = { "", "" },
					UDim2 = { "", "", "", "" },
					Color3_RGB = { "R: ", "G: ", "B: " },
					Color3_HSV = { "H: ", "S: ", "V: " },
					Color4_RGB = { "R: ", "G: ", "B: ", "T: " },
					Color4_HSV = { "H: ", "S: ", "V: ", "T: " },
					Rect = { "X: ", "Y: ", "X: ", "Y: " },
				}
			
				local defaultSigFigs: { [InputDataTypes]: { number } } = {
					Num = { 0 },
					Vector2 = { 0, 0 },
					Vector3 = { 0, 0, 0 },
					UDim = { 3, 0 },
					UDim2 = { 3, 0, 3, 0 },
					Color3 = { 0, 0, 0 },
					Color4 = { 0, 0, 0, 0 },
					Rect = { 0, 0, 0, 0 },
				}
			
				--[[
					Input
				]]
				local generateInputScalar: (dataType: InputDataTypes, components: number, defaultValue: any) -> WidgetClass
				do
					local function generateButtons(thisWidget: Widget, parent: GuiObject, rightPadding: number, textHeight: number)
						rightPadding += 2 * Iris._config.ItemInnerSpacing.X + 2 * textHeight
			
						local SubButton = widgets.abstractButton.Generate(thisWidget) :: TextButton
						SubButton.Name = "SubButton"
						SubButton.ZIndex = thisWidget.ZIndex + 5
						SubButton.LayoutOrder = thisWidget.ZIndex + 5
						SubButton.TextXAlignment = Enum.TextXAlignment.Center
						SubButton.Text = "-"
						SubButton.Size = UDim2.fromOffset(Iris._config.TextSize + 2 * Iris._config.FramePadding.Y, Iris._config.TextSize)
						SubButton.Parent = parent
			
						widgets.applyButtonClick(thisWidget, SubButton, function()
							local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
							local changeValue: number = (thisWidget.arguments.Increment and getValueByIndex(thisWidget.arguments.Increment, 1, thisWidget.arguments) or 1) * (isCtrlHeld and 100 or 1)
							local newValue: number = thisWidget.state.number.value - changeValue
							if thisWidget.arguments.Min ~= nil then
								newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, 1, thisWidget.arguments))
							end
							if thisWidget.arguments.Max ~= nil then
								newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, 1, thisWidget.arguments))
							end
							thisWidget.state.number:set(newValue)
							thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
						end)
			
						local AddButton = widgets.abstractButton.Generate(thisWidget) :: TextButton
						AddButton.Name = "AddButton"
						AddButton.ZIndex = thisWidget.ZIndex + 6
						AddButton.LayoutOrder = thisWidget.ZIndex + 6
						AddButton.TextXAlignment = Enum.TextXAlignment.Center
						AddButton.Text = "+"
						AddButton.Size = UDim2.fromOffset(Iris._config.TextSize + 2 * Iris._config.FramePadding.Y, Iris._config.TextSize)
						AddButton.Parent = parent
			
						widgets.applyButtonClick(thisWidget, AddButton, function()
							local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
							local changeValue: number = (thisWidget.arguments.Increment and getValueByIndex(thisWidget.arguments.Increment, 1, thisWidget.arguments) or 1) * (isCtrlHeld and 100 or 1)
							local newValue: number = thisWidget.state.number.value + changeValue
							if thisWidget.arguments.Min ~= nil then
								newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, 1, thisWidget.arguments))
							end
							if thisWidget.arguments.Max ~= nil then
								newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, 1, thisWidget.arguments))
							end
							thisWidget.state.number:set(newValue)
							thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
						end)
			
						return rightPadding
					end
			
					function generateInputScalar(dataType: InputDataTypes, components: number, defaultValue: any)
						return {
							hasState = true,
							hasChildren = false,
							Args = {
								["Text"] = 1,
								["Increment"] = 2,
								["Min"] = 3,
								["Max"] = 4,
								["Format"] = 5,
							},
							Events = {
								["numberChanged"] = numberChanged,
								["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
									return thisWidget.Instance
								end),
							},
							Generate = function(thisWidget: Widget)
								local Input: Frame = Instance.new("Frame")
								Input.Name = "Iris_Input" .. dataType
								Input.Size = UDim2.fromScale(1, 0)
								Input.BackgroundTransparency = 1
								Input.BorderSizePixel = 0
								Input.ZIndex = thisWidget.ZIndex
								Input.LayoutOrder = thisWidget.ZIndex
								Input.AutomaticSize = Enum.AutomaticSize.Y
								widgets.UIListLayout(Input, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
								-- we add plus and minus buttons if there is only one box. This can be disabled through the argument.
								local rightPadding: number = 0
								local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
			
								if components == 1 then
									rightPadding = generateButtons(thisWidget, Input, rightPadding, textHeight)
								end
			
								-- we divide the total area evenly between each field. This includes accounting for any additional boxes and the offset.
								-- for the final field, we make sure it's flush by calculating the space avaiable for it. This only makes the Vector2 box
								-- 4 pixels shorter, all for the sake of flush.
								local componentWidth: UDim = UDim.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1)) - rightPadding) / components)
								local totalWidth: UDim = UDim.new(componentWidth.Scale * (components - 1), (componentWidth.Offset * (components - 1)) + (Iris._config.ItemInnerSpacing.X * (components - 1)) + rightPadding)
								local lastComponentWidth: UDim = Iris._config.ContentWidth - totalWidth
			
								-- we handle each component individually since they don't need to interact with each other.
								for index = 1, components do
									local InputField: TextBox = Instance.new("TextBox")
									InputField.Name = "InputField" .. tostring(index)
									InputField.ZIndex = thisWidget.ZIndex + index
									InputField.LayoutOrder = thisWidget.ZIndex + index
									if index == components then
										InputField.Size = UDim2.new(lastComponentWidth, UDim.new())
									else
										InputField.Size = UDim2.new(componentWidth, UDim.new())
									end
									InputField.AutomaticSize = Enum.AutomaticSize.Y
									InputField.BackgroundColor3 = Iris._config.FrameBgColor
									InputField.BackgroundTransparency = Iris._config.FrameBgTransparency
									InputField.ClearTextOnFocus = false
									InputField.TextTruncate = Enum.TextTruncate.AtEnd
									InputField.ClipsDescendants = true
			
									widgets.applyFrameStyle(InputField)
									widgets.applyTextStyle(InputField)
									widgets.UISizeConstraint(InputField, Vector2.new(1, 0))
			
									InputField.Parent = Input
			
									InputField.FocusLost:Connect(function()
										local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
										if newValue ~= nil then
											if thisWidget.arguments.Min ~= nil then
												newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments))
											end
											if thisWidget.arguments.Max ~= nil then
												newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments))
											end
			
											if thisWidget.arguments.Increment then
												newValue = math.round(newValue / getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)) * getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											end
			
											thisWidget.state.number:set(updateValueByIndex(thisWidget.state.number.value, index, newValue, thisWidget.arguments))
											thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
										end
										local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
										if thisWidget.arguments.Prefix then
											format = thisWidget.arguments.Prefix[index] .. format
										end
										InputField.Text = string.format(format, getValueByIndex(thisWidget.state.number.value, index, thisWidget.arguments))
			
										thisWidget.state.editingText:set(0)
									end)
			
									InputField.Focused:Connect(function()
										-- this highlights the entire field
										InputField.CursorPosition = #InputField.Text + 1
										InputField.SelectionStart = 1
			
										thisWidget.state.editingText:set(index)
									end)
								end
			
								local TextLabel: TextLabel = Instance.new("TextLabel")
								TextLabel.Name = "TextLabel"
								TextLabel.Size = UDim2.fromOffset(0, textHeight)
								TextLabel.BackgroundTransparency = 1
								TextLabel.BorderSizePixel = 0
								TextLabel.ZIndex = thisWidget.ZIndex + 7
								TextLabel.LayoutOrder = thisWidget.ZIndex + 7
								TextLabel.AutomaticSize = Enum.AutomaticSize.X
			
								widgets.applyTextStyle(TextLabel)
			
								TextLabel.Parent = Input
			
								return Input
							end,
							Update = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
								local TextLabel: TextLabel = Input.TextLabel
								TextLabel.Text = thisWidget.arguments.Text or `Input {dataType}`
			
								if components == 1 then
									Input.SubButton.Visible = not thisWidget.arguments.NoButtons
									Input.AddButton.Visible = not thisWidget.arguments.NoButtons
								end
			
								if thisWidget.arguments.Format and typeof(thisWidget.arguments.Format) ~= "table" then
									thisWidget.arguments.Format = { thisWidget.arguments.Format }
								elseif not thisWidget.arguments.Format then
									-- we calculate the format for the s.f. using the max, min and increment arguments.
									local format: { string } = {}
									for index = 1, components do
										local sigfigs: number = defaultSigFigs[dataType][index]
			
										if thisWidget.arguments.Increment then
											local value: number = getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Max then
											local value: number = getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Min then
											local value: number = getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if sigfigs > 0 then
											-- we know it's a float.
											format[index] = `%.{sigfigs}f`
										else
											format[index] = "%d"
										end
									end
			
									thisWidget.arguments.Format = format
									thisWidget.arguments.Prefix = defaultPrefx[dataType]
								end
							end,
							Discard = function(thisWidget: Widget)
								thisWidget.Instance:Destroy()
								widgets.discardState(thisWidget)
							end,
							GenerateState = function(thisWidget: Widget)
								if thisWidget.state.number == nil then
									thisWidget.state.number = Iris._widgetState(thisWidget, "number", defaultValue)
								end
								if thisWidget.state.editingText == nil then
									thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", 0)
								end
							end,
							UpdateState = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
			
								for index = 1, components do
									local InputField: TextBox = Input:FindFirstChild("InputField" .. tostring(index))
									local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
									if thisWidget.arguments.Prefix then
										format = thisWidget.arguments.Prefix[index] .. format
									end
									InputField.Text = string.format(format, getValueByIndex(thisWidget.state.number.value, index, thisWidget.arguments))
								end
							end,
						}
					end
				end
			
				--[[
					Drag
				]]
				local generateDragScalar: (dataType: InputDataTypes, components: number, defaultValue: any) -> WidgetClass
				local generateColorDragScalar: (dataType: InputDataTypes, ...any) -> WidgetClass
				do
					local PreviouseMouseXPosition: number = 0
					local AnyActiveDrag: boolean = false
					local ActiveDrag: Widget? = nil
					local ActiveIndex: number = 0
					local ActiveDataType: InputDataTypes | "" = ""
			
					local function updateActiveDrag()
						local currentMouseX: number = widgets.getMouseLocation().X
						local mouseXDelta: number = currentMouseX - PreviouseMouseXPosition
						PreviouseMouseXPosition = currentMouseX
						if AnyActiveDrag == false then
							return
						end
						if ActiveDrag == nil then
							return
						end
			
						local state: State = ActiveDrag.state.number
						if ActiveDataType == "Color3" or ActiveDataType == "Color4" then
							state = ActiveDrag.state.color
							if ActiveIndex == 4 then
								state = ActiveDrag.state.transparency
							end
						end
			
						local increment: number = ActiveDrag.arguments.Increment and getValueByIndex(ActiveDrag.arguments.Increment, ActiveIndex, ActiveDrag.arguments) or defaultIncrements[ActiveDataType][ActiveIndex]
						increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1
						increment *= (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1
						-- we increase the speed for Color3 and Color4 since it's too slow because the increment argument needs to be low.
						increment *= (ActiveDataType == "Color3" or ActiveDataType == "Color4") and 5 or 1
			
						local value: number = getValueByIndex(state.value, ActiveIndex, ActiveDrag.arguments)
						local newValue: number = value + (mouseXDelta * increment)
			
						if ActiveDrag.arguments.Min ~= nil then
							newValue = math.max(newValue, getValueByIndex(ActiveDrag.arguments.Min, ActiveIndex, ActiveDrag.arguments))
						end
						if ActiveDrag.arguments.Max ~= nil then
							newValue = math.min(newValue, getValueByIndex(ActiveDrag.arguments.Max, ActiveIndex, ActiveDrag.arguments))
						end
			
						state:set(updateValueByIndex(state.value, ActiveIndex, newValue, ActiveDrag.arguments))
						ActiveDrag.lastNumberChangedTick = Iris._cycleTick + 1
					end
			
					local function DragMouseDown(thisWidget: Widget, dataTypes: InputDataTypes, index: number, x: number, y: number)
						local currentTime: number = widgets.getTime()
						local isTimeValid: boolean = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
						local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
						if (isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist) or isCtrlHeld then
							thisWidget.state.editingText:set(index)
						else
							thisWidget.lastClickedTime = currentTime
							thisWidget.lastClickedPosition = Vector2.new(x, y)
			
							AnyActiveDrag = true
							ActiveDrag = thisWidget
							ActiveIndex = index
							ActiveDataType = dataTypes
							updateActiveDrag()
						end
					end
			
					widgets.registerEvent("InputChanged", function()
						if not Iris._started then
							return
						end
						updateActiveDrag()
					end)
			
					widgets.registerEvent("InputEnded", function(inputObject: InputObject)
						if not Iris._started then
							return
						end
						if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and AnyActiveDrag then
							AnyActiveDrag = false
							ActiveDrag = nil
							ActiveIndex = 0
						end
					end)
			
					function generateDragScalar(dataType: InputDataTypes, components: number, defaultValue: any)
						return {
							hasState = true,
							hasChildren = false,
							Args = {
								["Text"] = 1,
								["Increment"] = 2,
								["Min"] = 3,
								["Max"] = 4,
								["Format"] = 5,
							},
							Events = {
								["numberChanged"] = numberChanged,
								["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
									return thisWidget.Instance
								end),
							},
							Generate = function(thisWidget: Widget)
								thisWidget.lastClickedTime = -1
								thisWidget.lastClickedPosition = Vector2.zero
			
								local Drag: Frame = Instance.new("Frame")
								Drag.Name = "Iris_Drag" .. dataType
								Drag.Size = UDim2.fromScale(1, 0)
								Drag.BackgroundTransparency = 1
								Drag.BorderSizePixel = 0
								Drag.ZIndex = thisWidget.ZIndex
								Drag.LayoutOrder = thisWidget.ZIndex
								Drag.AutomaticSize = Enum.AutomaticSize.Y
								widgets.UIListLayout(Drag, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
								-- we add a color box if it is Color3 or Color4.
								local rightPadding: number = 0
								local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
			
								if dataType == "Color3" or dataType == "Color4" then
									rightPadding += Iris._config.ItemInnerSpacing.X + textHeight
			
									local ColorBox: ImageLabel = Instance.new("ImageLabel")
									ColorBox.Name = "ColorBox"
									ColorBox.BorderSizePixel = 0
									ColorBox.Size = UDim2.fromOffset(textHeight, textHeight)
									ColorBox.ZIndex = thisWidget.ZIndex + 5
									ColorBox.LayoutOrder = thisWidget.ZIndex + 5
									ColorBox.Image = widgets.ICONS.ALPHA_BACKGROUND_TEXTURE
									ColorBox.ImageTransparency = 1
			
									widgets.applyFrameStyle(ColorBox, true, true)
			
									ColorBox.Parent = Drag
								end
			
								-- we divide the total area evenly between each field. This includes accounting for any additional boxes and the offset.
								-- for the final field, we make sure it's flush by calculating the space avaiable for it. This only makes the Vector2 box
								-- 4 pixels shorter, all for the sake of flush.
								local componentWidth: UDim = UDim.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1)) - rightPadding) / components)
								local totalWidth: UDim = UDim.new(componentWidth.Scale * (components - 1), (componentWidth.Offset * (components - 1)) + (Iris._config.ItemInnerSpacing.X * (components - 1)) + rightPadding)
								local lastComponentWidth: UDim = Iris._config.ContentWidth - totalWidth
			
								for index = 1, components do
									local DragField: TextButton = Instance.new("TextButton")
									DragField.Name = "DragField" .. tostring(index)
									DragField.ZIndex = thisWidget.ZIndex + index
									DragField.LayoutOrder = thisWidget.ZIndex + index
									if index == components then
										DragField.Size = UDim2.new(lastComponentWidth, UDim.new())
									else
										DragField.Size = UDim2.new(componentWidth, UDim.new())
									end
									DragField.AutomaticSize = Enum.AutomaticSize.Y
									DragField.BackgroundColor3 = Iris._config.FrameBgColor
									DragField.BackgroundTransparency = Iris._config.FrameBgTransparency
									DragField.AutoButtonColor = false
									DragField.Text = ""
									DragField.ClipsDescendants = true
			
									widgets.applyFrameStyle(DragField)
									widgets.applyTextStyle(DragField)
									widgets.UISizeConstraint(DragField, Vector2.new(1, 0))
			
									DragField.TextXAlignment = Enum.TextXAlignment.Center
			
									DragField.Parent = Drag
			
									widgets.applyInteractionHighlights(thisWidget, DragField, DragField, {
										ButtonColor = Iris._config.FrameBgColor,
										ButtonTransparency = Iris._config.FrameBgTransparency,
										ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
										ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
										ButtonActiveColor = Iris._config.FrameBgActiveColor,
										ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
									})
			
									local InputField: TextBox = Instance.new("TextBox")
									InputField.Name = "InputField"
									InputField.ZIndex = thisWidget.ZIndex + 5
									InputField.LayoutOrder = thisWidget.ZIndex + 2
									InputField.Size = UDim2.new(1, 0, 1, 0)
									InputField.BackgroundTransparency = 1
									InputField.ClearTextOnFocus = false
									InputField.TextTruncate = Enum.TextTruncate.AtEnd
									InputField.ClipsDescendants = true
									InputField.Visible = false
			
									widgets.applyFrameStyle(InputField, true)
									widgets.applyTextStyle(InputField)
			
									InputField.Parent = DragField
			
									InputField.FocusLost:Connect(function()
										local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
										local state: State = thisWidget.state.number
										if dataType == "Color4" and index == 4 then
											state = thisWidget.state.transparency
										elseif dataType == "Color3" or dataType == "Color4" then
											state = thisWidget.state.color
										end
										if newValue ~= nil then
											if dataType == "Color3" or dataType == "Color4" and not thisWidget.arguments.UseFloats then
												newValue = newValue / 255
											end
											if thisWidget.arguments.Min ~= nil then
												newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments))
											end
											if thisWidget.arguments.Max ~= nil then
												newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments))
											end
			
											if thisWidget.arguments.Increment then
												newValue = math.round(newValue / getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)) * getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											end
			
											state:set(updateValueByIndex(state.value, index, newValue, thisWidget.arguments))
											thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
										end
			
										local value: number = getValueByIndex(state.value, index, thisWidget.arguments)
										if dataType == "Color3" or dataType == "Color4" and not thisWidget.arguments.UseFloats then
											value = math.round(value * 255)
										end
			
										local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
										if thisWidget.arguments.Prefix then
											format = thisWidget.arguments.Prefix[index] .. format
										end
										InputField.Text = string.format(format, value)
			
										thisWidget.state.editingText:set(0)
										InputField:ReleaseFocus(true)
									end)
			
									InputField.Focused:Connect(function()
										-- this highlights the entire field
										InputField.CursorPosition = #InputField.Text + 1
										InputField.SelectionStart = 1
			
										thisWidget.state.editingText:set(index)
									end)
			
									widgets.applyButtonDown(thisWidget, DragField, function(x: number, y: number)
										DragMouseDown(thisWidget, dataType, index, x, y)
									end)
								end
			
								local TextLabel: TextLabel = Instance.new("TextLabel")
								TextLabel.Name = "TextLabel"
								TextLabel.Size = UDim2.fromOffset(0, textHeight)
								TextLabel.BackgroundTransparency = 1
								TextLabel.BorderSizePixel = 0
								TextLabel.ZIndex = thisWidget.ZIndex + 5
								TextLabel.LayoutOrder = thisWidget.ZIndex + 5
								TextLabel.AutomaticSize = Enum.AutomaticSize.X
			
								widgets.applyTextStyle(TextLabel)
			
								TextLabel.Parent = Drag
			
								return Drag
							end,
							Update = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
								local TextLabel: TextLabel = Input.TextLabel
								TextLabel.Text = thisWidget.arguments.Text or `Drag {dataType}`
			
								if thisWidget.arguments.Format and typeof(thisWidget.arguments.Format) ~= "table" then
									thisWidget.arguments.Format = { thisWidget.arguments.Format }
								elseif not thisWidget.arguments.Format then
									-- we calculate the format for the s.f. using the max, min and increment arguments.
									local format: { string } = {}
									for index = 1, components do
										local sigfigs: number = defaultSigFigs[dataType][index]
			
										if thisWidget.arguments.Increment then
											local value: number = getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Max then
											local value: number = getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Min then
											local value: number = getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if sigfigs > 0 then
											-- we know it's a float.
											format[index] = `%.{sigfigs}f`
										else
											format[index] = "%d"
										end
									end
			
									thisWidget.arguments.Format = format
									thisWidget.arguments.Prefix = defaultPrefx[dataType]
								end
							end,
							Discard = function(thisWidget: Widget)
								thisWidget.Instance:Destroy()
								widgets.discardState(thisWidget)
							end,
							GenerateState = function(thisWidget: Widget)
								if thisWidget.state.number == nil then
									thisWidget.state.number = Iris._widgetState(thisWidget, "number", defaultValue)
								end
								if thisWidget.state.editingText == nil then
									thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
								end
							end,
							UpdateState = function(thisWidget: Widget)
								local Drag = thisWidget.Instance :: Frame
			
								for index = 1, components do
									local state: State = thisWidget.state.number
									if dataType == "Color3" or dataType == "Color4" then
										state = thisWidget.state.color
										if index == 4 then
											state = thisWidget.state.transparency
										end
									end
									local DragField = Drag:FindFirstChild("DragField" .. tostring(index)) :: TextButton
									local InputField: TextBox = DragField.InputField
									local value: number = getValueByIndex(state.value, index, thisWidget.arguments)
									if (dataType == "Color3" or dataType == "Color4") and not thisWidget.arguments.UseFloats then
										value = math.round(value * 255)
									end
			
									local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
									if thisWidget.arguments.Prefix then
										format = thisWidget.arguments.Prefix[index] .. format
									end
									DragField.Text = string.format(format, value)
									InputField.Text = tostring(value)
			
									if thisWidget.state.editingText.value == index then
										InputField.Visible = true
										InputField:CaptureFocus()
										DragField.TextTransparency = 1
									else
										InputField.Visible = false
										DragField.TextTransparency = Iris._config.TextTransparency
									end
								end
			
								if dataType == "Color3" or dataType == "Color4" then
									local ColorBox: ImageLabel = Drag.ColorBox
			
									ColorBox.BackgroundColor3 = thisWidget.state.color.value
			
									if dataType == "Color4" then
										ColorBox.ImageTransparency = 1 - thisWidget.state.transparency.value
									end
								end
							end,
						}
					end
			
					function generateColorDragScalar(dataType: InputDataTypes, ...: any)
						local defaultValues: { any } = { ... }
						local input: WidgetClass = generateDragScalar(dataType, dataType == "Color4" and 4 or 3, defaultValues[1])
			
						return widgets.extend(input, {
							Args = {
								["Text"] = 1,
								["UseFloats"] = 2,
								["UseHSV"] = 3,
								["Format"] = 4,
							},
							Update = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
								local TextLabel: TextLabel = Input.TextLabel
								TextLabel.Text = thisWidget.arguments.Text or `Drag {dataType}`
			
								if thisWidget.arguments.Format and typeof(thisWidget.arguments.Format) ~= "table" then
									thisWidget.arguments.Format = { thisWidget.arguments.Format }
								elseif not thisWidget.arguments.Format then
									if thisWidget.arguments.UseFloats then
										thisWidget.arguments.Format = { "%.3f" }
									else
										thisWidget.arguments.Format = { "%d" }
									end
			
									thisWidget.arguments.Prefix = defaultPrefx[dataType .. if thisWidget.arguments.UseHSV then "_HSV" else "_RGB"]
								end
			
								thisWidget.arguments.Min = { 0, 0, 0, 0 }
								thisWidget.arguments.Max = { 1, 1, 1, 1 }
								thisWidget.arguments.Increment = { 0.001, 0.001, 0.001, 0.001 }
			
								-- since the state values have changed display, we call an update. The check is because state is not
								-- initialised on creation, so it would error otherwise.
								if thisWidget.state then
									Iris._widgets[thisWidget.type].UpdateState(thisWidget)
								end
							end,
							GenerateState = function(thisWidget: Widget)
								if thisWidget.state.color == nil then
									thisWidget.state.color = Iris._widgetState(thisWidget, "color", defaultValues[1])
								end
								if dataType == "Color4" then
									if thisWidget.state.transparency == nil then
										thisWidget.state.transparency = Iris._widgetState(thisWidget, "transparency", defaultValues[2])
									end
								end
								if thisWidget.state.editingText == nil then
									thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
								end
							end,
						})
					end
				end
			
				--[[
					Slider
				]]
				local generateSliderScalar: (dataType: InputDataTypes, components: number, defaultValue: any) -> WidgetClass
				local generateEnumSliderScalar: (enum: Enum, item: EnumItem) -> WidgetClass
				do
					local AnyActiveSlider: boolean = false
					local ActiveSlider: Widget? = nil
					local ActiveIndex: number = 0
					local ActiveDataType: InputDataTypes | "" = ""
			
					local function updateActiveSlider()
						if AnyActiveSlider == false then
							return
						end
						if ActiveSlider == nil then
							return
						end
			
						local Slider = ActiveSlider.Instance :: Frame
						local SliderField = Slider:FindFirstChild("SliderField" .. tostring(ActiveIndex)) :: TextButton
						local GrabBar: Frame = SliderField.GrabBar
			
						local increment: number = ActiveSlider.arguments.Increment and getValueByIndex(ActiveSlider.arguments.Increment, ActiveIndex, ActiveSlider.arguments) or defaultIncrements[ActiveDataType][ActiveIndex]
						local min: number = ActiveSlider.arguments.Min and getValueByIndex(ActiveSlider.arguments.Min, ActiveIndex, ActiveSlider.arguments) or defaultMin[ActiveDataType][ActiveIndex]
						local max: number = ActiveSlider.arguments.Max and getValueByIndex(ActiveSlider.arguments.Max, ActiveIndex, ActiveSlider.arguments) or defaultMax[ActiveDataType][ActiveIndex]
			
						local GrabWidth: number = GrabBar.AbsoluteSize.X
						local Offset: number = widgets.getMouseLocation().X - (SliderField.AbsolutePosition.X + GrabWidth / 2)
						local Ratio: number = Offset / (SliderField.AbsoluteSize.X - GrabWidth)
						local Positions: number = math.floor((max - min) / increment)
						local newValue: number = math.clamp(math.round(Ratio * Positions) * increment + min, min, max)
			
						ActiveSlider.state.number:set(updateValueByIndex(ActiveSlider.state.number.value, ActiveIndex, newValue, ActiveSlider.arguments))
						ActiveSlider.lastNumberChangedTick = Iris._cycleTick + 1
					end
			
					local function SliderMouseDown(thisWidget: Widget, dataType: InputDataTypes, index: number)
						local isCtrlHeld: boolean = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
						if isCtrlHeld then
							thisWidget.state.editingText:set(index)
						else
							AnyActiveSlider = true
							ActiveSlider = thisWidget
							ActiveIndex = index
							ActiveDataType = dataType
							updateActiveSlider()
						end
					end
			
					widgets.registerEvent("InputChanged", function()
						if not Iris._started then
							return
						end
						updateActiveSlider()
					end)
			
					widgets.registerEvent("InputEnded", function(inputObject: InputObject)
						if not Iris._started then
							return
						end
						if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and AnyActiveSlider then
							AnyActiveSlider = false
							ActiveSlider = nil
							ActiveIndex = 0
							ActiveDataType = ""
						end
					end)
			
					function generateSliderScalar(dataType: InputDataTypes, components: number, defaultValue: any, ...: any)
						return {
							hasState = true,
							hasChildren = false,
							Args = {
								["Text"] = 1,
								["Increment"] = 2,
								["Min"] = 3,
								["Max"] = 4,
								["Format"] = 5,
							},
							Events = {
								["numberChanged"] = numberChanged,
								["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
									return thisWidget.Instance
								end),
							},
							Generate = function(thisWidget: Widget)
								local Slider: Frame = Instance.new("Frame")
								Slider.Name = "Iris_Slider" .. dataType
								Slider.Size = UDim2.fromScale(1, 0)
								Slider.BackgroundTransparency = 1
								Slider.BorderSizePixel = 0
								Slider.ZIndex = thisWidget.ZIndex
								Slider.LayoutOrder = thisWidget.ZIndex
								Slider.AutomaticSize = Enum.AutomaticSize.Y
								widgets.UIListLayout(Slider, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
								local textHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
			
								-- we divide the total area evenly between each field. This includes accounting for any additional boxes and the offset.
								-- for the final field, we make sure it's flush by calculating the space avaiable for it. This only makes the Vector2 box
								-- 4 pixels shorter, all for the sake of flush.
								local componentWidth: UDim = UDim.new(Iris._config.ContentWidth.Scale / components, (Iris._config.ContentWidth.Offset - (Iris._config.ItemInnerSpacing.X * (components - 1))) / components)
								local totalWidth: UDim = UDim.new(componentWidth.Scale * (components - 1), (componentWidth.Offset * (components - 1)) + (Iris._config.ItemInnerSpacing.X * (components - 1)))
								local lastComponentWidth: UDim = Iris._config.ContentWidth - totalWidth
			
								for index = 1, components do
									local SliderField: TextButton = Instance.new("TextButton")
									SliderField.Name = "SliderField" .. tostring(index)
									SliderField.ZIndex = thisWidget.ZIndex + index
									SliderField.LayoutOrder = thisWidget.ZIndex + index
									if index == components then
										SliderField.Size = UDim2.new(lastComponentWidth, UDim.new())
									else
										SliderField.Size = UDim2.new(componentWidth, UDim.new())
									end
									SliderField.AutomaticSize = Enum.AutomaticSize.Y
									SliderField.BackgroundColor3 = Iris._config.FrameBgColor
									SliderField.BackgroundTransparency = Iris._config.FrameBgTransparency
									SliderField.AutoButtonColor = false
									SliderField.Text = ""
									SliderField.ClipsDescendants = true
			
									widgets.applyFrameStyle(SliderField)
									widgets.applyTextStyle(SliderField)
									widgets.UISizeConstraint(SliderField, Vector2.new(1, 0))
			
									SliderField.Parent = Slider
			
									local OverlayText = Instance.new("TextLabel")
									OverlayText.Name = "OverlayText"
									OverlayText.Size = UDim2.fromScale(1, 1)
									OverlayText.BackgroundTransparency = 1
									OverlayText.BorderSizePixel = 0
									OverlayText.ZIndex = thisWidget.ZIndex + 10
									OverlayText.ClipsDescendants = true
			
									widgets.applyTextStyle(OverlayText)
			
									OverlayText.TextXAlignment = Enum.TextXAlignment.Center
			
									OverlayText.Parent = SliderField
			
									widgets.applyInteractionHighlights(thisWidget, SliderField, SliderField, {
										ButtonColor = Iris._config.FrameBgColor,
										ButtonTransparency = Iris._config.FrameBgTransparency,
										ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
										ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
										ButtonActiveColor = Iris._config.FrameBgActiveColor,
										ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
									})
			
									local InputField: TextBox = Instance.new("TextBox")
									InputField.Name = "InputField"
									InputField.ZIndex = thisWidget.ZIndex + 5
									InputField.LayoutOrder = thisWidget.ZIndex + 2
									InputField.Size = UDim2.new(1, 0, 1, 0)
									InputField.BackgroundTransparency = 1
									InputField.ClearTextOnFocus = false
									InputField.TextTruncate = Enum.TextTruncate.AtEnd
									InputField.ClipsDescendants = true
									InputField.Visible = false
			
									widgets.applyFrameStyle(InputField, true)
									widgets.applyTextStyle(InputField)
			
									InputField.Parent = SliderField
			
									InputField.FocusLost:Connect(function()
										local newValue: number? = tonumber(InputField.Text:match("-?%d*%.?%d*"))
										if newValue ~= nil then
											if thisWidget.arguments.Min ~= nil then
												newValue = math.max(newValue, getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments))
											end
											if thisWidget.arguments.Max ~= nil then
												newValue = math.min(newValue, getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments))
											end
			
											if thisWidget.arguments.Increment then
												newValue = math.round(newValue / getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)) * getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											end
			
											thisWidget.state.number:set(updateValueByIndex(thisWidget.state.number.value, index, newValue, thisWidget.arguments))
											thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
										end
			
										local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
										if thisWidget.arguments.Prefix then
											format = thisWidget.arguments.Prefix[index] .. format
										end
			
										InputField.Text = string.format(format, getValueByIndex(thisWidget.state.number.value, index, thisWidget.arguments))
			
										thisWidget.state.editingText:set(0)
										InputField:ReleaseFocus(true)
									end)
			
									InputField.Focused:Connect(function()
										-- this highlights the entire field
										InputField.CursorPosition = #InputField.Text + 1
										InputField.SelectionStart = 1
			
										thisWidget.state.editingText:set(index)
									end)
			
									widgets.applyButtonDown(thisWidget, SliderField, function()
										SliderMouseDown(thisWidget, dataType, index)
									end)
			
									local GrabBar: Frame = Instance.new("Frame")
									GrabBar.Name = "GrabBar"
									GrabBar.ZIndex = thisWidget.ZIndex + 5
									GrabBar.LayoutOrder = thisWidget.ZIndex + 5
									GrabBar.AnchorPoint = Vector2.new(0.5, 0.5)
									GrabBar.Position = UDim2.new(0, 0, 0.5, 0)
									GrabBar.BorderSizePixel = 0
									GrabBar.BackgroundColor3 = Iris._config.SliderGrabColor
									GrabBar.Transparency = Iris._config.SliderGrabTransparency
									if Iris._config.GrabRounding > 0 then
										widgets.UICorner(GrabBar, Iris._config.GrabRounding)
									end
			
									widgets.UISizeConstraint(GrabBar, Vector2.new(Iris._config.GrabMinSize, 0))
			
									GrabBar.Parent = SliderField
								end
			
								local TextLabel: TextLabel = Instance.new("TextLabel")
								TextLabel.Name = "TextLabel"
								TextLabel.Size = UDim2.fromOffset(0, textHeight)
								TextLabel.BackgroundTransparency = 1
								TextLabel.BorderSizePixel = 0
								TextLabel.ZIndex = thisWidget.ZIndex + 5
								TextLabel.LayoutOrder = thisWidget.ZIndex + 5
								TextLabel.AutomaticSize = Enum.AutomaticSize.X
			
								widgets.applyTextStyle(TextLabel)
			
								TextLabel.Parent = Slider
			
								return Slider
							end,
							Update = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
								local TextLabel: TextLabel = Input.TextLabel
								TextLabel.Text = thisWidget.arguments.Text or `Slider {dataType}`
			
								if thisWidget.arguments.Format and typeof(thisWidget.arguments.Format) ~= "table" then
									thisWidget.arguments.Format = { thisWidget.arguments.Format }
								elseif not thisWidget.arguments.Format then
									-- we calculate the format for the s.f. using the max, min and increment arguments.
									local format: { string } = {}
									for index = 1, components do
										local sigfigs: number = defaultSigFigs[dataType][index]
			
										if thisWidget.arguments.Increment then
											local value: number = getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Max then
											local value: number = getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if thisWidget.arguments.Min then
											local value: number = getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments)
											sigfigs = math.max(sigfigs, math.ceil(-math.log10(value == 0 and 1 or value)), sigfigs)
										end
			
										if sigfigs > 0 then
											-- we know it's a float.
											format[index] = `%.{sigfigs}f`
										else
											format[index] = "%d"
										end
									end
			
									thisWidget.arguments.Format = format
									thisWidget.arguments.Prefix = defaultPrefx[dataType]
								end
			
								for index = 1, components do
									local SliderField = Input:FindFirstChild("SliderField" .. tostring(index)) :: TextButton
									local GrabBar: Frame = SliderField.GrabBar
			
									local increment: number = thisWidget.arguments.Increment and getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments) or defaultIncrements[dataType][index]
									local min: number = thisWidget.arguments.Min and getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments) or defaultMin[dataType][index]
									local max: number = thisWidget.arguments.Max and getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments) or defaultMax[dataType][index]
			
									local grabScaleSize: number = 1 / math.floor((1 + max - min) / increment)
			
									GrabBar.Size = UDim2.new(grabScaleSize, 0, 1, 0)
								end
			
								local callbackIndex: number = #Iris._postCycleCallbacks + 1
								local desiredCycleTick: number = Iris._cycleTick + 1
								Iris._postCycleCallbacks[callbackIndex] = function()
									if Iris._cycleTick == desiredCycleTick then
										Iris._widgets[`Slider{dataType}`].UpdateState(thisWidget)
										Iris._postCycleCallbacks[callbackIndex] = nil
									end
								end
							end,
							Discard = function(thisWidget: Widget)
								thisWidget.Instance:Destroy()
								widgets.discardState(thisWidget)
							end,
							GenerateState = function(thisWidget: Widget)
								if thisWidget.state.number == nil then
									thisWidget.state.number = Iris._widgetState(thisWidget, "number", defaultValue)
								end
								if thisWidget.state.editingText == nil then
									thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
								end
							end,
							UpdateState = function(thisWidget: Widget)
								local Slider = thisWidget.Instance :: Frame
			
								for index = 1, components do
									local SliderField = Slider:FindFirstChild("SliderField" .. tostring(index)) :: TextButton
									local InputField: TextBox = SliderField.InputField
									local OverlayText: TextLabel = SliderField.OverlayText
									local GrabBar: Frame = SliderField.GrabBar
			
									local value: number = getValueByIndex(thisWidget.state.number.value, index, thisWidget.arguments)
									local format: string = thisWidget.arguments.Format[index] or thisWidget.arguments.Format[1]
									if thisWidget.arguments.Prefix then
										format = thisWidget.arguments.Prefix[index] .. format
									end
			
									OverlayText.Text = string.format(format, value)
									InputField.Text = tostring(value)
			
									local increment: number = thisWidget.arguments.Increment and getValueByIndex(thisWidget.arguments.Increment, index, thisWidget.arguments) or defaultIncrements[dataType][index]
									local min: number = thisWidget.arguments.Min and getValueByIndex(thisWidget.arguments.Min, index, thisWidget.arguments) or defaultMin[dataType][index]
									local max: number = thisWidget.arguments.Max and getValueByIndex(thisWidget.arguments.Max, index, thisWidget.arguments) or defaultMax[dataType][index]
			
									local SliderWidth: number = SliderField.AbsoluteSize.X
									local PaddedWidth: number = SliderWidth - GrabBar.AbsoluteSize.X
									local Ratio: number = (value - min) / (max - min)
									local Positions: number = math.floor((max - min) / increment)
									local ClampedRatio: number = math.clamp(math.floor((Ratio * Positions)) / Positions, 0, 1)
									local PaddedRatio: number = ((PaddedWidth / SliderWidth) * ClampedRatio) + ((1 - (PaddedWidth / SliderWidth)) / 2)
			
									GrabBar.Position = UDim2.new(PaddedRatio, 0, 0.5, 0)
			
									if thisWidget.state.editingText.value == index then
										InputField.Visible = true
										OverlayText.Visible = false
										GrabBar.Visible = false
										InputField:CaptureFocus()
									else
										InputField.Visible = false
										OverlayText.Visible = true
										GrabBar.Visible = true
									end
								end
							end,
						}
					end
			
					function generateEnumSliderScalar(enum: Enum, item: EnumItem)
						local input: WidgetClass = generateSliderScalar("Enum", 1, item.Value)
						local valueToName = { string }
			
						for _, enumItem: EnumItem in enum:GetEnumItems() do
							valueToName[enumItem.Value] = enumItem.Name
						end
			
						return widgets.extend(input, {
							Args = {
								["Text"] = 1,
							},
							Update = function(thisWidget: Widget)
								local Input = thisWidget.Instance :: GuiObject
								local TextLabel: TextLabel = Input.TextLabel
								TextLabel.Text = thisWidget.arguments.Text or "Input Enum"
			
								thisWidget.arguments.Increment = 1
								thisWidget.arguments.Min = 0
								thisWidget.arguments.Max = #enum:GetEnumItems() - 1
			
								local SliderField = Input:FindFirstChild("SliderField1") :: TextButton
								local GrabBar: Frame = SliderField.GrabBar
			
								local grabScaleSize: number = 1 / math.floor(#enum:GetEnumItems())
			
								GrabBar.Size = UDim2.new(grabScaleSize, 0, 1, 0)
							end,
							GenerateState = function(thisWidget: Widget)
								if thisWidget.state.number == nil then
									thisWidget.state.number = Iris._widgetState(thisWidget, "number", item.Value)
								end
								if thisWidget.state.enumItem == nil then
									thisWidget.state.enumItem = Iris._widgetState(thisWidget, "enumItem", item)
								end
								if thisWidget.state.editingText == nil then
									thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
								end
							end,
						})
					end
				end
			
				do
					local inputNum: WidgetClass = generateInputScalar("Num", 1, 0)
					inputNum.Args["NoButtons"] = 6
					Iris.WidgetConstructor("InputNum", inputNum)
				end
				Iris.WidgetConstructor("InputVector2", generateInputScalar("Vector2", 2, Vector2.zero))
				Iris.WidgetConstructor("InputVector3", generateInputScalar("Vector3", 3, Vector3.zero))
				Iris.WidgetConstructor("InputUDim", generateInputScalar("UDim", 2, UDim.new()))
				Iris.WidgetConstructor("InputUDim2", generateInputScalar("UDim2", 4, UDim2.new()))
				Iris.WidgetConstructor("InputRect", generateInputScalar("Rect", 4, Rect.new(0, 0, 0, 0)))
			
				Iris.WidgetConstructor("DragNum", generateDragScalar("Num", 1, 0))
				Iris.WidgetConstructor("DragVector2", generateDragScalar("Vector2", 2, Vector2.zero))
				Iris.WidgetConstructor("DragVector3", generateDragScalar("Vector3", 3, Vector3.zero))
				Iris.WidgetConstructor("DragUDim", generateDragScalar("UDim", 2, UDim.new()))
				Iris.WidgetConstructor("DragUDim2", generateDragScalar("UDim2", 4, UDim2.new()))
				Iris.WidgetConstructor("DragRect", generateDragScalar("Rect", 4, Rect.new(0, 0, 0, 0)))
			
				Iris.WidgetConstructor("InputColor3", generateColorDragScalar("Color3", Color3.fromRGB(0, 0, 0)))
				Iris.WidgetConstructor("InputColor4", generateColorDragScalar("Color4", Color3.fromRGB(0, 0, 0), 0))
			
				Iris.WidgetConstructor("SliderNum", generateSliderScalar("Num", 1, 0))
				Iris.WidgetConstructor("SliderVector2", generateSliderScalar("Vector2", 2, Vector2.zero))
				Iris.WidgetConstructor("SliderVector3", generateSliderScalar("Vector3", 3, Vector3.zero))
				Iris.WidgetConstructor("SliderUDim", generateSliderScalar("UDim", 2, UDim.new()))
				Iris.WidgetConstructor("SliderUDim2", generateSliderScalar("UDim2", 4, UDim2.new()))
				Iris.WidgetConstructor("SliderRect", generateSliderScalar("Rect", 4, Rect.new(0, 0, 0, 0)))
				-- Iris.WidgetConstructor("SliderEnum", generateSliderScalar("Enum", 4, 0))
			
				--stylua: ignore
				Iris.WidgetConstructor("InputText", {
					hasState = true,
					hasChildren = false,
					Args = {
						["Text"] = 1,
						["TextHint"] = 2,
					},
					Events = {
						["textChanged"] = {
							["Init"] = function(thisWidget: Widget)
								thisWidget.lastTextchangeTick = 0
							end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastTextchangeTick == Iris._cycleTick
							end,
						},
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local InputText: Frame = Instance.new("Frame")
						InputText.Name = "Iris_InputText"
						InputText.AutomaticSize = Enum.AutomaticSize.Y
						InputText.Size = UDim2.fromScale(1, 0)
						InputText.BackgroundTransparency = 1
						InputText.BorderSizePixel = 0
						InputText.ZIndex = thisWidget.ZIndex
						InputText.LayoutOrder = thisWidget.ZIndex
						widgets.UIListLayout(InputText, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
						local InputField: TextBox = Instance.new("TextBox")
						InputField.Name = "InputField"
						InputField.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
						InputField.AutomaticSize = Enum.AutomaticSize.Y
						InputField.BackgroundColor3 = Iris._config.FrameBgColor
						InputField.BackgroundTransparency = Iris._config.FrameBgTransparency
						InputField.Text = ""
						InputField.PlaceholderColor3 = Iris._config.TextDisabledColor
						InputField.TextTruncate = Enum.TextTruncate.AtEnd
						InputField.ClearTextOnFocus = false
						InputField.ZIndex = thisWidget.ZIndex + 1
						InputField.LayoutOrder = thisWidget.ZIndex + 1
						InputField.ClipsDescendants = true
			
						widgets.applyFrameStyle(InputField)
						widgets.applyTextStyle(InputField)
						widgets.UISizeConstraint(InputField, Vector2.new(1, 0)) -- prevents sizes beaking when getting too small.
						-- InputField.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
						-- InputField.UIPadding.PaddingRight = UDim.new(0, 0)
						InputField.Parent = InputText
			
						InputField.FocusLost:Connect(function()
							thisWidget.state.text:set(InputField.Text)
							thisWidget.lastTextchangeTick = Iris._cycleTick + 1
						end)
			
						local frameHeight: number = Iris._config.TextSize + Iris._config.FramePadding.Y * 2
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						TextLabel.Size = UDim2.fromOffset(0, frameHeight)
						TextLabel.AutomaticSize = Enum.AutomaticSize.X
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.ZIndex = thisWidget.ZIndex + 4
						TextLabel.LayoutOrder = thisWidget.ZIndex + 4
			
						widgets.applyTextStyle(TextLabel)
			
						TextLabel.Parent = InputText
			
						return InputText
					end,
					Update = function(thisWidget: Widget)
						local InputText = thisWidget.Instance :: Frame
						local TextLabel: TextLabel = InputText.TextLabel
						local InputField: TextBox = InputText.InputField
			
						TextLabel.Text = thisWidget.arguments.Text or "Input Text"
						InputField.PlaceholderText = thisWidget.arguments.TextHint or ""
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.text == nil then
							thisWidget.state.text = Iris._widgetState(thisWidget, "text", "")
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local InputText = thisWidget.Instance :: Frame
						local InputField: TextBox = InputText.InputField
			
						InputField.Text = thisWidget.state.text.value
					end,
				} :: WidgetClass)
			end
		end)()
		local combo = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local function onSelectionChange(thisWidget)
					if type(thisWidget.state.index.value) == "boolean" then
						thisWidget.state.index:set(not thisWidget.state.index.value)
					else
						thisWidget.state.index:set(thisWidget.arguments.Index)
					end
				end
			
				--stylua: ignore
				Iris.WidgetConstructor("Selectable", {
					hasState = true,
					hasChildren = false,
					Args = {
						["Text"] = 1,
						["Index"] = 2,
						["NoClick"] = 3,
					},
					Events = {
						["selected"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastSelectedTick == Iris._cycleTick
							end,
						},
						["unselected"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastUnselectedTick == Iris._cycleTick
							end,
						},
						["active"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.state.index.value == thisWidget.arguments.Index
							end,
						},
						["clicked"] = widgets.EVENTS.click(function(thisWidget: Widget)
							local Selectable = thisWidget.Instance :: Frame
							return Selectable.SelectableButton
						end),
						["rightClicked"] = widgets.EVENTS.rightClick(function(thisWidget: Widget)
							local Selectable = thisWidget.Instance :: Frame
							return Selectable.SelectableButton
						end),
						["doubleClicked"] = widgets.EVENTS.doubleClick(function(thisWidget: Widget)
							local Selectable = thisWidget.Instance :: Frame
							return Selectable.SelectableButton
						end),
						["ctrlClicked"] = widgets.EVENTS.ctrlClick(function(thisWidget: Widget)
							local Selectable = thisWidget.Instance :: Frame
							return Selectable.SelectableButton
						end),
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							local Selectable = thisWidget.Instance :: Frame
							return Selectable.SelectableButton
						end),
					},
					Generate = function(thisWidget: Widget): Frame
						local Selectable: Frame = Instance.new("Frame")
						Selectable.Name = "Iris_Selectable"
						Selectable.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, Iris._config.TextSize))
						Selectable.AutomaticSize = Enum.AutomaticSize.None
						Selectable.BackgroundTransparency = 1
						Selectable.BorderSizePixel = 0
						Selectable.ZIndex = thisWidget.ZIndex
						Selectable.LayoutOrder = thisWidget.ZIndex
			
						local SelectableButton: TextButton = Instance.new("TextButton")
						SelectableButton.Name = "SelectableButton"
						SelectableButton.Size = UDim2.new(1, 0, 1, Iris._config.ItemSpacing.Y - 1)
						SelectableButton.Position = UDim2.fromOffset(0, -bit32.rshift(Iris._config.ItemSpacing.Y, 1))
						SelectableButton.BackgroundColor3 = Iris._config.HeaderColor
						SelectableButton.ZIndex = thisWidget.ZIndex + 1
						SelectableButton.LayoutOrder = thisWidget.ZIndex + 1
			
						widgets.applyFrameStyle(SelectableButton)
						widgets.applyTextStyle(SelectableButton)
			
						thisWidget.ButtonColors = {
							ButtonColor = Iris._config.HeaderColor,
							ButtonTransparency = 1,
							ButtonHoveredColor = Iris._config.HeaderHoveredColor,
							ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
							ButtonActiveColor = Iris._config.HeaderActiveColor,
							ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
						}
			
						widgets.applyInteractionHighlights(thisWidget, SelectableButton, SelectableButton, thisWidget.ButtonColors)
			
						widgets.applyButtonClick(thisWidget, SelectableButton, function()
							if thisWidget.arguments.NoClick ~= true then
								onSelectionChange(thisWidget)
							end
						end)
			
						SelectableButton.Parent = Selectable
			
						return Selectable
					end,
					Update = function(thisWidget: Widget)
						local Selectable = thisWidget.Instance :: Frame
						local SelectableButton: TextButton = Selectable.SelectableButton
						SelectableButton.Text = thisWidget.arguments.Text or "Selectable"
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.index == nil then
							if thisWidget.arguments.Index ~= nil then
								error("a shared state index is required for Selectables with an Index argument", 5)
							end
							thisWidget.state.index = Iris._widgetState(thisWidget, "index", false)
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local Selectable = thisWidget.Instance :: Frame
						local SelectableButton: TextButton = Selectable.SelectableButton
						if thisWidget.state.index.value == (thisWidget.arguments.Index or true) then
							thisWidget.ButtonColors.ButtonTransparency = Iris._config.HeaderTransparency
							SelectableButton.BackgroundTransparency = Iris._config.HeaderTransparency
							thisWidget.lastSelectedTick = Iris._cycleTick + 1
						else
							thisWidget.ButtonColors.ButtonTransparency = 1
							SelectableButton.BackgroundTransparency = 1
							thisWidget.lastUnselectedTick = Iris._cycleTick + 1
						end
					end,
				} :: WidgetClass)
			
				local AnyOpenedCombo: boolean = false
				local ComboOpenedTick: number = -1
				local OpenedCombo: Widget? = nil
			
				local function UpdateChildContainerTransform(thisWidget: Widget)
					local Iris_Combo = thisWidget.Instance :: Frame
					local PreviewContainer = Iris_Combo.PreviewContainer :: TextButton
					local PreviewLabel: TextLabel = PreviewContainer.PreviewLabel
					local ChildContainer = thisWidget.ChildContainer :: ScrollingFrame
			
					local labelHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
			
					local borderWidth: number = Iris._config.PopupBorderSize
					local ChildContainerHeight: number = (labelHeight * math.min(thisWidget.ComboChildrenHeight, 8) - 2 * borderWidth) + (3 * Iris._config.FramePadding.Y)
					local ChildContainerWidth: UDim = UDim.new(0, PreviewContainer.AbsoluteSize.X - 2 * borderWidth)
					ChildContainer.Size = UDim2.new(ChildContainerWidth, UDim.new(0, ChildContainerHeight))
			
					local ScreenSize: Vector2 = ChildContainer.Parent.AbsoluteSize
			
					if PreviewLabel.AbsolutePosition.Y + labelHeight + ChildContainerHeight > ScreenSize.Y then
						-- too large to fit below the Combo, so is placed above
						ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + borderWidth, 0, PreviewLabel.AbsolutePosition.Y - borderWidth - ChildContainerHeight)
					else
						ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + borderWidth, 0, PreviewLabel.AbsolutePosition.Y + labelHeight + borderWidth)
					end
				end
			
				widgets.registerEvent("InputBegan", function(inputObject: InputObject)
					if not Iris._started then
						return
					end
					if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 or inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 or inputObject.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if AnyOpenedCombo == false or not OpenedCombo then
						return
					end
					if ComboOpenedTick == Iris._cycleTick then
						return
					end
					local MouseLocation: Vector2 = widgets.getMouseLocation()
					local ChildContainer = OpenedCombo.ChildContainer
					local rectMin: Vector2 = ChildContainer.AbsolutePosition - Vector2.new(0, OpenedCombo.LabelHeight)
					local rectMax: Vector2 = ChildContainer.AbsolutePosition + ChildContainer.AbsoluteSize
					if not widgets.isPosInsideRect(MouseLocation, rectMin, rectMax) then
						OpenedCombo.state.isOpened:set(false)
					end
				end)
			
				--stylua: ignore
				Iris.WidgetConstructor("Combo", {
					hasState = true,
					hasChildren = true,
					Args = {
						["Text"] = 1,
						["NoButton"] = 2,
						["NoPreview"] = 3,
					},
					Events = {
						["opened"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastOpenedTick == Iris._cycleTick
							end,
						},
						["closed"] = {
							["Init"] = function(_thisWidget: Widget) end,
							["Get"] = function(thisWidget: Widget)
								return thisWidget.lastClosedTick == Iris._cycleTick
							end,
						},
						["clicked"] = widgets.EVENTS.click(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						local frameHeight: number = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
						thisWidget.ComboChildrenHeight = 0
			
						local Combo: Frame = Instance.new("Frame")
						Combo.Name = "Iris_Combo"
						Combo.Size = UDim2.fromScale(1, 0)
						Combo.AutomaticSize = Enum.AutomaticSize.Y
						Combo.BackgroundTransparency = 1
						Combo.BorderSizePixel = 0
						Combo.ZIndex = thisWidget.ZIndex
						Combo.LayoutOrder = thisWidget.ZIndex
			
						widgets.UIListLayout(Combo, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.Y + 1))
			
						local PreviewContainer: TextButton = Instance.new("TextButton")
						PreviewContainer.Name = "PreviewContainer"
						PreviewContainer.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
						PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y
						PreviewContainer.BackgroundTransparency = 1
						PreviewContainer.Text = ""
						PreviewContainer.ZIndex = thisWidget.ZIndex + 2
						PreviewContainer.LayoutOrder = thisWidget.ZIndex + 2
						PreviewContainer.AutoButtonColor = false
			
						widgets.applyFrameStyle(PreviewContainer, true, true)
						widgets.UIListLayout(PreviewContainer, Enum.FillDirection.Horizontal, UDim.new(0, 0))
			
						PreviewContainer.Parent = Combo
			
						local PreviewLabel: TextLabel = Instance.new("TextLabel")
						PreviewLabel.Name = "PreviewLabel"
						PreviewLabel.Size = UDim2.new(1, 0, 0, 0)
						PreviewLabel.AutomaticSize = Enum.AutomaticSize.Y
						PreviewLabel.BackgroundColor3 = Iris._config.FrameBgColor
						PreviewLabel.BackgroundTransparency = Iris._config.FrameBgTransparency
						PreviewLabel.BorderSizePixel = 0
						PreviewLabel.ZIndex = thisWidget.ZIndex + 3
						PreviewLabel.LayoutOrder = thisWidget.ZIndex + 3
			
						widgets.applyTextStyle(PreviewLabel)
						widgets.UIPadding(PreviewLabel, Iris._config.FramePadding)
			
						PreviewLabel.Parent = PreviewContainer
			
						local DropdownButton: TextLabel = Instance.new("TextLabel")
						DropdownButton.Name = "DropdownButton"
						DropdownButton.Size = UDim2.new(0, frameHeight, 0, frameHeight)
						DropdownButton.BorderSizePixel = 0
						DropdownButton.BackgroundColor3 = Iris._config.ButtonColor
						DropdownButton.BackgroundTransparency = Iris._config.ButtonTransparency
						DropdownButton.Text = ""
						DropdownButton.ZIndex = thisWidget.ZIndex + 4
						DropdownButton.LayoutOrder = thisWidget.ZIndex + 4
			
						local padding: number = math.round(frameHeight * 0.2)
						local dropdownSize: number = frameHeight - 2 * padding
			
						local Dropdown: ImageLabel = Instance.new("ImageLabel")
						Dropdown.Name = "Dropdown"
						Dropdown.Size = UDim2.fromOffset(dropdownSize, dropdownSize)
						Dropdown.Position = UDim2.fromOffset(padding, padding)
						Dropdown.BackgroundTransparency = 1
						Dropdown.BorderSizePixel = 0
						Dropdown.ImageColor3 = Iris._config.TextColor
						Dropdown.ImageTransparency = Iris._config.TextTransparency
						Dropdown.ZIndex = thisWidget.ZIndex + 5
						Dropdown.LayoutOrder = thisWidget.ZIndex + 5
			
						Dropdown.Parent = DropdownButton
						DropdownButton.Parent = PreviewContainer
			
						-- for some reason ImGui Combo has no highlights for Active, only hovered.
						-- so this deviates from ImGui, but its a good UX change
						widgets.applyInteractionHighlightsWithMultiHighlightee(thisWidget, PreviewContainer, {
							{
								PreviewLabel,
								{
									ButtonColor = Iris._config.FrameBgColor,
									ButtonTransparency = Iris._config.FrameBgTransparency,
									ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
									ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
									ButtonActiveColor = Iris._config.FrameBgActiveColor,
									ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
								},
							},
							{
								DropdownButton,
								{
									ButtonColor = Iris._config.ButtonColor,
									ButtonTransparency = Iris._config.ButtonTransparency,
									ButtonHoveredColor = Iris._config.ButtonHoveredColor,
									ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
									-- Use hovered for active
									ButtonActiveColor = Iris._config.ButtonHoveredColor,
									ButtonActiveTransparency = Iris._config.ButtonHoveredTransparency,
								},
							},
						})
			
						PreviewContainer.InputBegan:Connect(function(inputObject)
							if AnyOpenedCombo and OpenedCombo ~= thisWidget then
								return
							end
							if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
								thisWidget.state.isOpened:set(not thisWidget.state.isOpened.value)
							end
						end)
			
						local TextLabel: TextLabel = Instance.new("TextLabel")
						TextLabel.Name = "TextLabel"
						TextLabel.Size = UDim2.fromOffset(0, frameHeight)
						TextLabel.AutomaticSize = Enum.AutomaticSize.X
						TextLabel.BackgroundTransparency = 1
						TextLabel.BorderSizePixel = 0
						TextLabel.ZIndex = thisWidget.ZIndex + 5
						TextLabel.LayoutOrder = thisWidget.ZIndex + 5
			
						widgets.applyTextStyle(TextLabel)
			
						TextLabel.Parent = Combo
			
						local ChildContainer: ScrollingFrame = Instance.new("ScrollingFrame")
						ChildContainer.Name = "ChildContainer"
						ChildContainer.BackgroundColor3 = Iris._config.WindowBgColor
						ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
						ChildContainer.BorderSizePixel = 0
			
						ChildContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
						ChildContainer.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency
						ChildContainer.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
						ChildContainer.ScrollBarThickness = Iris._config.ScrollbarSize
						ChildContainer.CanvasSize = UDim2.fromScale(0, 0)
						ChildContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			
						-- appear over everything else
						ChildContainer.ZIndex = thisWidget.ZIndex + 6
						ChildContainer.LayoutOrder = thisWidget.ZIndex + 6
						ChildContainer.ClipsDescendants = true
			
						-- Unfortunatley, ScrollingFrame does not work with UICorner
						-- if Iris._config.PopupRounding > 0 then
						--     widgets.UICorner(ChildContainer, Iris._config.PopupRounding)
						-- end
			
						widgets.UIStroke(ChildContainer, Iris._config.WindowBorderSize, Iris._config.BorderColor, Iris._config.BorderTransparency)
						widgets.UIPadding(ChildContainer, Vector2.new(2, 2 * Iris._config.FramePadding.Y))
			
						local ChildContainerUIListLayout: UIListLayout = widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
						ChildContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			
						local RootPopupScreenGui = Iris._rootInstance and Iris._rootInstance:WaitForChild("PopupScreenGui") :: GuiObject
						ChildContainer.Parent = RootPopupScreenGui
						thisWidget.ChildContainer = ChildContainer
			
						return Combo
					end,
					Update = function(thisWidget: Widget)
						local Iris_Combo = thisWidget.Instance :: Frame
						local PreviewContainer = Iris_Combo.PreviewContainer :: TextButton
						local PreviewLabel: TextLabel = PreviewContainer.PreviewLabel
						local DropdownButton: TextLabel = PreviewContainer.DropdownButton
						local TextLabel: TextLabel = Iris_Combo.TextLabel
			
						TextLabel.Text = thisWidget.arguments.Text or "Combo"
			
						if thisWidget.arguments.NoButton then
							DropdownButton.Visible = false
							PreviewLabel.Size = UDim2.new(1, 0, 0, 0)
						else
							DropdownButton.Visible = true
							local DropdownButtonSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
							PreviewLabel.Size = UDim2.new(1, -DropdownButtonSize, 0, 0)
						end
			
						if thisWidget.arguments.NoPreview then
							PreviewLabel.Visible = false
							PreviewContainer.Size = UDim2.new(0, 0, 0, 0)
							PreviewContainer.AutomaticSize = Enum.AutomaticSize.X
						else
							PreviewLabel.Visible = true
							PreviewContainer.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
							PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y
						end
					end,
					ChildAdded = function(thisWidget: Widget, thisChild: Widget)
						-- default to largest size if there are widgets other than selectables inside the combo
						if thisChild.type ~= "Selectable" then
							thisWidget.ComboChildrenHeight += 10
						else
							thisWidget.ComboChildrenHeight += 1
						end
						UpdateChildContainerTransform(thisWidget)
						return thisWidget.ChildContainer
					end,
					ChildDiscarded = function(thisWidget: Widget, thisChild: Widget)
						if thisChild.type ~= "Selectable" then
							thisWidget.ComboChildrenHeight -= 10
						else
							thisWidget.ComboChildrenHeight -= 1
						end
					end,
					GenerateState = function(thisWidget: Widget)
						if thisWidget.state.index == nil then
							thisWidget.state.index = Iris._widgetState(thisWidget, "index", "No Selection")
						end
						thisWidget.state.index:onChange(function()
							if thisWidget.state.isOpened.value then
								thisWidget.state.isOpened:set(false)
							end
						end)
						if thisWidget.state.isOpened == nil then
							thisWidget.state.isOpened = Iris._widgetState(thisWidget, "isOpened", false)
						end
					end,
					UpdateState = function(thisWidget: Widget)
						local Iris_Combo = thisWidget.Instance :: Frame
						local PreviewContainer = Iris_Combo.PreviewContainer :: TextButton
						local PreviewLabel: TextLabel = PreviewContainer.PreviewLabel
						local DropdownButton = PreviewContainer.DropdownButton :: TextLabel
						local Dropdown: ImageLabel = DropdownButton.Dropdown
						local ChildContainer = thisWidget.ChildContainer :: ScrollingFrame
			
						if thisWidget.state.isOpened.value then
							AnyOpenedCombo = true
							OpenedCombo = thisWidget
							ComboOpenedTick = Iris._cycleTick
							thisWidget.lastOpenedTick = Iris._cycleTick + 1
			
							-- ImGui also does not do this, and the Arrow is always facing down
							Dropdown.Image = widgets.ICONS.RIGHT_POINTING_TRIANGLE
							ChildContainer.Visible = true
			
							UpdateChildContainerTransform(thisWidget)
						else
							if AnyOpenedCombo then
								AnyOpenedCombo = false
								OpenedCombo = nil
								thisWidget.lastClosedTick = Iris._cycleTick + 1
							end
							Dropdown.Image = widgets.ICONS.DOWN_POINTING_TRIANGLE
							ChildContainer.Visible = false
						end
			
						local stateIndex: any = thisWidget.state.index.value
						PreviewLabel.Text = if typeof(stateIndex) == "EnumItem" then stateIndex.Name else tostring(stateIndex)
					end,
					Discard = function(thisWidget: Widget)
						thisWidget.Instance:Destroy()
						widgets.discardState(thisWidget)
					end,
				} :: WidgetClass)
			end
		end)()
		local plot = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				Iris.WidgetConstructor(
					"ProgressBar",
					{
						hasState = true,
						hasChildren = false,
						Args = {
							["Text"] = 1,
							["Format"] = 2,
						},
						Events = {
							["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
								return thisWidget.Instance
							end),
							["changed"] = {
								["Init"] = function(_thisWidget: Widget) end,
								["Get"] = function(thisWidget: Widget)
									return thisWidget.lastNumberChangedTick == Iris._cycleTick
								end,
							},
						},
						Generate = function(thisWidget: Widget)
							local ProgressBar: Frame = Instance.new("Frame")
							ProgressBar.Name = "Iris_ProgressBar"
							ProgressBar.Size = UDim2.new(Iris._config.ItemWidth, UDim.new())
							ProgressBar.BackgroundTransparency = 1
							ProgressBar.AutomaticSize = Enum.AutomaticSize.Y
							ProgressBar.ZIndex = thisWidget.ZIndex
							ProgressBar.LayoutOrder = thisWidget.ZIndex
			
							widgets.UIListLayout(ProgressBar, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))
			
							local Bar: Frame = Instance.new("Frame")
							Bar.Name = "Bar"
							Bar.Size = UDim2.new(Iris._config.ContentWidth, UDim.new())
							Bar.BackgroundColor3 = Iris._config.FrameBgColor
							Bar.BackgroundTransparency = Iris._config.FrameBgTransparency
							Bar.BorderSizePixel = 0
							Bar.AutomaticSize = Enum.AutomaticSize.Y
							Bar.ClipsDescendants = true
							Bar.ZIndex = thisWidget.ZIndex + 1
							Bar.LayoutOrder = thisWidget.ZIndex + 1
			
							widgets.applyFrameStyle(Bar, true, true)
			
							Bar.Parent = ProgressBar
			
							local Progress: TextLabel = Instance.new("TextLabel")
							Progress.Name = "Progress"
							Progress.BackgroundColor3 = Iris._config.PlotHistogramColor
							Progress.BackgroundTransparency = Iris._config.PlotHistogramTransparency
							Progress.BorderSizePixel = 0
							Progress.AutomaticSize = Enum.AutomaticSize.Y
							Progress.ZIndex = thisWidget.ZIndex + 2
							Progress.LayoutOrder = thisWidget.ZIndex + 2
			
							widgets.applyTextStyle(Progress)
							widgets.UIPadding(Progress, Iris._config.FramePadding)
							widgets.UICorner(Progress, Iris._config.FrameRounding)
			
							Progress.Text = ""
							Progress.Parent = Bar
			
							local Value: TextLabel = Instance.new("TextLabel")
							Value.Name = "Value"
							Value.AutomaticSize = Enum.AutomaticSize.XY
							Value.BackgroundTransparency = 1
							Value.BorderSizePixel = 0
							Value.ZIndex = thisWidget.ZIndex + 3
							Value.LayoutOrder = thisWidget.ZIndex + 3
			
							widgets.applyTextStyle(Value)
							widgets.UIPadding(Value, Iris._config.FramePadding)
			
							Value.Parent = Bar
			
							local TextLabel: TextLabel = Instance.new("TextLabel")
							TextLabel.Name = "TextLabel"
							TextLabel.AnchorPoint = Vector2.new(0, 0.5)
							TextLabel.AutomaticSize = Enum.AutomaticSize.XY
							TextLabel.BackgroundTransparency = 1
							TextLabel.BorderSizePixel = 0
							TextLabel.ZIndex = thisWidget.ZIndex + 4
							TextLabel.LayoutOrder = thisWidget.ZIndex + 4
			
							widgets.applyTextStyle(TextLabel)
							widgets.UIPadding(Value, Iris._config.FramePadding)
			
							TextLabel.Parent = ProgressBar
			
							return ProgressBar
						end,
						GenerateState = function(thisWidget: Widget)
							if thisWidget.state.progress == nil then
								thisWidget.state.progress = Iris._widgetState(thisWidget, "Progress", 0)
							end
						end,
						Update = function(thisWidget: Widget)
							local Progress = thisWidget.Instance :: Frame
							local TextLabel: TextLabel = Progress.TextLabel
							local Bar = Progress.Bar :: Frame
							local Value: TextLabel = Bar.Value
			
							if thisWidget.arguments.Format ~= nil and typeof(thisWidget.arguments.Format) == "string" then
								Value.Text = thisWidget.arguments.Format
							end
			
							TextLabel.Text = thisWidget.arguments.Text or "Progress Bar"
						end,
						UpdateState = function(thisWidget: Widget)
							local ProgressBar = thisWidget.Instance :: Frame
							local Bar = ProgressBar.Bar :: Frame
							local Progress: TextLabel = Bar.Progress
							local Value: TextLabel = Bar.Value
			
							local progress: number = thisWidget.state.progress.value
							progress = math.clamp(progress, 0, 1)
							local totalWidth: number = Bar.AbsoluteSize.X
							local textWidth: number = Value.AbsoluteSize.X
							if totalWidth * (1 - progress) < textWidth then
								Value.AnchorPoint = Vector2.xAxis
								Value.Position = UDim2.fromScale(1, 0)
							else
								Value.AnchorPoint = Vector2.zero
								Value.Position = UDim2.new(progress, 0, 0, 0)
							end
			
							Progress.Size = UDim2.fromScale(progress, 0)
							if thisWidget.arguments.Format ~= nil and typeof(thisWidget.arguments.Format) == "string" then
								Value.Text = thisWidget.arguments.Format
							else
								Value.Text = string.format("%d%%", progress * 100)
							end
							thisWidget.lastNumberChangedTick = Iris._cycleTick + 1
						end,
						Discard = function(thisWidget: Widget)
							thisWidget.Instance:Destroy()
							widgets.discardState(thisWidget)
						end,
					} :: WidgetClass
				)
			end
		end)()

		local tabl = (function()
			return function(Iris: Internal, widgets: WidgetUtility)
				local tableWidgets: { [ID]: Widget } = {}
			
				-- reset the cell index every frame.
				table.insert(Iris._postCycleCallbacks, function()
					for _, thisWidget: Widget in tableWidgets do
						thisWidget.RowColumnIndex = 0
					end
				end)
			
				--stylua: ignore
				Iris.WidgetConstructor("Table", {
					hasState = false,
					hasChildren = true,
					Args = {
						["NumColumns"] = 1,
						["RowBg"] = 2,
						["BordersOuter"] = 3,
						["BordersInner"] = 4,
					},
					Events = {
						["hovered"] = widgets.EVENTS.hover(function(thisWidget: Widget)
							return thisWidget.Instance
						end),
					},
					Generate = function(thisWidget: Widget)
						tableWidgets[thisWidget.ID] = thisWidget
			
						thisWidget.InitialNumColumns = -1
						thisWidget.RowColumnIndex = 0
						-- reference to these is stored as an optimization
						thisWidget.ColumnInstances = {}
						thisWidget.CellInstances = {}
			
						local Table: Frame = Instance.new("Frame")
						Table.Name = "Iris_Table"
						Table.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
						Table.AutomaticSize = Enum.AutomaticSize.Y
						Table.BackgroundTransparency = 1
						Table.BorderSizePixel = 0
						Table.ZIndex = thisWidget.ZIndex + 1024 -- allocate room for 1024 cells, because Table UIStroke has to appear above cell UIStroke
						Table.LayoutOrder = thisWidget.ZIndex
						Table.ClipsDescendants = true
			
						widgets.UIListLayout(Table, Enum.FillDirection.Horizontal, UDim.new(0, 0))
						widgets.UIStroke(Table, 1, Iris._config.TableBorderStrongColor, Iris._config.TableBorderStrongTransparency)
			
						return Table
					end,
					Update = function(thisWidget: Widget)
						local Table = thisWidget.Instance :: Frame
			
						if thisWidget.arguments.BordersOuter == false then
							Table.UIStroke.Thickness = 0
						else
							Table.UIStroke.Thickness = 1
						end
			
						if thisWidget.InitialNumColumns == -1 then
							if thisWidget.arguments.NumColumns == nil then
								error("Iris.Table NumColumns argument is required", 5)
							end
							thisWidget.InitialNumColumns = thisWidget.arguments.NumColumns
			
							for index = 1, thisWidget.InitialNumColumns do
								local zindex: number = thisWidget.ZIndex + 1 + index
			
								local Column: Frame = Instance.new("Frame")
								Column.Name = `Column_{index}`
								Column.Size = UDim2.new(1 / thisWidget.InitialNumColumns, 0, 0, 0)
								Column.AutomaticSize = Enum.AutomaticSize.Y
								Column.BackgroundTransparency = 1
								Column.BorderSizePixel = 0
								Column.ZIndex = zindex
								Column.LayoutOrder = zindex
								Column.ClipsDescendants = true
			
								widgets.UIListLayout(Column, Enum.FillDirection.Vertical, UDim.new(0, 0))
			
								thisWidget.ColumnInstances[index] = Column
								Column.Parent = Table
							end
						elseif thisWidget.arguments.NumColumns ~= thisWidget.InitialNumColumns then
							-- its possible to make it so that the NumColumns can increase,
							-- but decreasing it would interfere with child widget instances
							error("Iris.Table NumColumns Argument must be static")
						end
			
						if thisWidget.arguments.RowBg == false then
							for _, Cell: Frame in thisWidget.CellInstances do
								Cell.BackgroundTransparency = 1
							end
						else
							for index: number, Cell: Frame in thisWidget.CellInstances do
								local currentRow: number = math.ceil(index / thisWidget.InitialNumColumns)
								Cell.BackgroundTransparency = if currentRow % 2 == 0 then Iris._config.TableRowBgAltTransparency else Iris._config.TableRowBgTransparency
							end
						end
			
						-- wooo, I love lua  Especially on an object and child based system like Roblox! I never have to do anything
						-- annoying or dumb to make it like me!
						if thisWidget.arguments.BordersInner == false then
							for _, Cell: Frame & { UIStroke: UIStroke } in thisWidget.CellInstances :: any do
								Cell.UIStroke.Thickness = 0
							end
						else
							for _, Cell: Frame & { UIStroke: UIStroke } in thisWidget.CellInstances :: any do
								Cell.UIStroke.Thickness = 0.5
							end
						end
					end,
					Discard = function(thisWidget: Widget)
						tableWidgets[thisWidget.ID] = nil
						thisWidget.Instance:Destroy()
					end,
					ChildAdded = function(thisWidget: Widget)
						if thisWidget.RowColumnIndex == 0 then
							thisWidget.RowColumnIndex = 1
						end
						local potentialCellParent: Frame = thisWidget.CellInstances[thisWidget.RowColumnIndex]
						if potentialCellParent then
							return potentialCellParent
						end
			
						local selectedParent: Frame = thisWidget.ColumnInstances[((thisWidget.RowColumnIndex - 1) % thisWidget.InitialNumColumns) + 1]
						local zindex: number = selectedParent.ZIndex + thisWidget.RowColumnIndex
			
						local Cell: Frame = Instance.new("Frame")
						Cell.Name = `Cell_{thisWidget.RowColumnIndex}`
						Cell.Size = UDim2.new(1, 0, 0, 0)
						Cell.AutomaticSize = Enum.AutomaticSize.Y
						Cell.BackgroundTransparency = 1
						Cell.BorderSizePixel = 0
						Cell.ZIndex = zindex
						Cell.LayoutOrder = zindex
						Cell.ClipsDescendants = true
			
						widgets.UIPadding(Cell, Iris._config.CellPadding)
						widgets.UIListLayout(Cell, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
			
						if thisWidget.arguments.BordersInner == false then
							widgets.UIStroke(Cell, 0, Iris._config.TableBorderLightColor, Iris._config.TableBorderLightTransparency)
						else
							widgets.UIStroke(Cell, 0.5, Iris._config.TableBorderLightColor, Iris._config.TableBorderLightTransparency)
							-- this takes advantage of unintended behavior when UIStroke is set to 0.5 to render cell borders,
							-- at 0.5, only the top and left side of the cell will be rendered with a border.
						end
			
						if thisWidget.arguments.RowBg ~= false then
							local currentRow: number = math.ceil(thisWidget.RowColumnIndex / thisWidget.InitialNumColumns)
							local color: Color3 = if currentRow % 2 == 0 then Iris._config.TableRowBgAltColor else Iris._config.TableRowBgColor
							local transparency: number = if currentRow % 2 == 0 then Iris._config.TableRowBgAltTransparency else Iris._config.TableRowBgTransparency
			
							Cell.BackgroundColor3 = color
							Cell.BackgroundTransparency = transparency
						end
			
						thisWidget.CellInstances[thisWidget.RowColumnIndex] = Cell
						Cell.Parent = selectedParent
						return Cell
					end,
				} :: WidgetClass)
			end
		end)()
		root(Iris, widgets)
		window(Iris, widgets)

		menu(Iris, widgets)

		format(Iris, widgets)

		text(Iris, widgets)
		button(Iris, widgets)
		checkbox(Iris, widgets)
		radioButton(Iris, widgets)

		tree(Iris, widgets)

		input(Iris, widgets)
		combo(Iris, widgets)
		plot(Iris, widgets)

		tabl(Iris, widgets)
	end
end)()
--------------------------------------------------------------------------------------------
-- lib/init.lua

--[=[
    @class Iris

    Iris; contains the all user-facing functions and properties.
    A set of internal functions can be found in `Iris.Internal` (only use unless you understand).
]=]
local Iris = {} :: Iris

local Internal: Internal = internal(Iris)

--[=[
    @prop Disabled boolean
    @within Iris

    While Iris.Disabled is true, execution of Iris and connected functions will be paused.
    The widgets are not destroyed, they are just frozen so no changes will happen to them.
]=]
Iris.Disabled = false

--[=[
    @prop Args table
    @within Iris

    Provides a list of every possible Argument for each type of widget to it's index.
    For instance, `Iris.Args.Window.NoResize`.
    The Args table is useful for using widget Arguments without remembering their order.
    ```lua
    Iris.Window({"My Window", [Iris.Args.Window.NoResize] = true})
    ```
]=]
Iris.Args = {}

--[=[
    @ignore
    @prop Events table
    @within Iris

    -todo: work out what this is used for.
]=]
Iris.Events = {}

--[=[
    @function Init
    @within Iris
    @param parentInstance Instance | nil -- instance which Iris will place UI in. defaults to [PlayerGui] if unspecified
    @param eventConnection RBXScriptSignal | () -> {} | nil
    @return Iris

    Initializes Iris and begins rendering. May only be called once.
    By default, Iris will create its widgets under the PlayerGui and use the Heartbeat event.
]=]
function Iris.Init(parentInstance: BasePlayerGui?, eventConnection: (RBXScriptSignal | () -> ())?, config: { [string]: any }?): Iris
    assert(Internal._started == false, "Iris.Init can only be called once.")
    assert(Internal._shutdown == false, "Iris.Init cannot be called once shutdown.")

    if parentInstance == nil then
        -- coalesce to playerGui
        parentInstance = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    if eventConnection == nil then
        -- coalesce to Heartbeat
        eventConnection = game:GetService("RunService").Heartbeat
    end
    Internal.parentInstance = parentInstance :: BasePlayerGui
    Internal._started = true

    Internal._generateRootInstance()
    Internal._generateSelectionImageObject()

    for _, callback: () -> () in Internal._initFunctions do
        callback()
    end

    -- spawns the connection to call `Internal._cycle()` within.
    task.spawn(function()
        if typeof(eventConnection) == "function" then
            while Internal._started do
                eventConnection()
                Internal._cycle()
            end
        elseif eventConnection ~= nil then
            Internal._eventConnection = eventConnection:Connect(function()
                Internal._cycle()
            end)
        end
    end)

    return Iris
end

--[=[
    @within Iris
    @method Shutdown
]=]
function Iris.Shutdown()
    Internal._started = false
    Internal._shutdown = true

    if Internal._eventConnection then
        Internal._eventConnection:Disconnect()
    end
    Internal._eventConnection = nil

    if Internal._rootWidget then
        if Internal._rootWidget.Instance then
            Internal._widgets["Root"].Discard(Internal._rootWidget)
        end
        Internal._rootInstance = nil
    end

    if Internal.SelectionImageObject then
        Internal.SelectionImageObject:Destroy()
    end

    for _, connection: RBXScriptConnection in Internal._connections do
        connection:Disconnect()
    end
end

--[=[
    @within Iris
    @method Connect
    @param callback function -- the callback containg the Iris code.
    
    Allows users to connect a function which will execute every Iris cycle, (cycle is determined by the callback or event passed to Iris.Init or default to Heartbeat).
    Multiple callbacks can be added to Iris from many different scripts or modules.
]=]
function Iris:Connect(callback: () -> ()) -- this uses method syntax for no reason.
    if Internal._started == false then
        warn("Iris:Connect() was called before calling Iris.Init(), the connected function will never run")
    end
    table.insert(Internal._connectedFunctions, callback)
end

--[=[
    @function Append
    @within Iris

    Allows the caller to insert any Roblox Instance into Iris. The parent can either be determined by the `_config.Parent`
    property or by the current parent widget from the stack.
]=]
function Iris.Append(userInstance: GuiObject)
    local parentWidget: Widget = Internal._GetParentWidget()
    local widgetInstanceParent: GuiObject
    if Internal._config.Parent then
        widgetInstanceParent = Internal._config.Parent :: any
    else
        widgetInstanceParent = Internal._widgets[parentWidget.type].ChildAdded(parentWidget, { type = "userInstance" } :: Widget)
    end
    userInstance.Parent = widgetInstanceParent
end

--[=[
    @function End
    @within Iris

    This function marks the end of any widgets which contain children. For example:
    ```lua
    -- Widgets placed here **will not** be inside the tree
    Iris.Tree({"My First Tree"})
        -- Widgets placed here **will** be inside the tree
    Iris.End()
    -- Widgets placed here **will not** be inside the tree
    ```
    :::caution Caution: Error
    Seeing the error `Callback has too few calls to Iris.End()` or `Callback has too many calls to Iris.End()`?
    Using the wrong amount of `Iris.End()` calls in your code will lead to an error. Each widget called which might have children should be paired with a call to `Iris.End()`, **Even if the Widget doesnt currently have any children**.
    :::
]=]
function Iris.End()
    if Internal._stackIndex == 1 then
        error("Callback has too many calls to Iris.End()", 2)
    end
    Internal._IDStack[Internal._stackIndex] = nil
    Internal._stackIndex -= 1
end

--[[
    ------------------------
        [SECTION] Config
    ------------------------
]]

--[=[
    @function ForceRefresh
    @within Iris

    Destroys and regenerates all instances used by Iris. Useful if you want to propogate state changes.
    :::caution Caution: Performance
    Because this function Deletes and Initializes many instances, it may cause **performance issues** when used with many widgets.
    In **no** case should it be called every frame.
    :::
]=]
function Iris.ForceRefresh()
    Internal._globalRefreshRequested = true
end

--[=[
    @function UpdateGlobalConfig
    @within Iris
    @param deltaStyle table -- a table containing the changes in style ex: `{ItemWidth = UDim.new(0, 100)}`

    Allows callers to customize the config which **every** widget will inherit from.
    It can be used along with Iris.TemplateConfig to easily swap styles, ex: ```Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorLight) -- use light theme```
    :::caution Caution: Performance
    this function internally calls [Iris.ForceRefresh] so that style changes are propogated, it may cause **performance issues** when used with many widgets.
    In **no** case should it be called every frame.
    :::
]=]
function Iris.UpdateGlobalConfig(deltaStyle: { [string]: any })
    for index, style in deltaStyle do
        Internal._rootConfig[index] = style
    end
    Iris.ForceRefresh()
end

--[=[
    @function PushConfig
    @within Iris
    @param deltaStyle table -- a table containing the changes in style ex: `{ItemWidth = UDim.new(0, 100)}`

    Allows callers to cascade a style, meaning that styles may be locally and hierarchically applied.
    Each call to Iris.PushConfig must be paired with a call to [Iris.PopConfig].
    For example:
    ```lua
    Iris.PushConfig({TextColor = Color3.fromRGB(128, 0, 256)})
        Iris.Text({"Colored Text!"})
    Iris.PopConfig()
    ```
]=]
function Iris.PushConfig(deltaStyle: { [string]: any })
    local ID = Iris.State(-1)
    if ID.value == -1 then
        ID:set(deltaStyle)
    else
        -- compare tables
        if Internal._deepCompare(ID:get(), deltaStyle) == false then
            -- refresh local
            Internal._localRefreshActive = true
            ID:set(deltaStyle)
        end
    end

    Internal._config = setmetatable(deltaStyle, {
        __index = Internal._config,
    }) :: any
end

--[=[
    @function PopConfig
    @within Iris

    Ends a PushConfig style.
    Each call to [Iris.PushConfig] must be paired with a call to Iris.PopConfig.
]=]
function Iris.PopConfig()
    Internal._localRefreshActive = false
    Internal._config = getmetatable(Internal._config :: any).__index
end

--[=[
    @prop TemplateConfig table
    @within Iris

    TemplateConfig provides a table of default styles and configurations which you may apply to your UI.
]=]
Iris.TemplateConfig = table.clone(TemplateConfig)
Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark) -- use colorDark and sizeDefault themes by default
Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
Iris.UpdateGlobalConfig(Iris.TemplateConfig.utilityDefault)
Internal._globalRefreshRequested = false -- UpdatingGlobalConfig changes this to true, leads to Root being generated twice.

--[[
    --------------------
        [SECTION] ID
    --------------------
]]

--[=[
    @function PushId
    @within Iris
    @param id ID -- custom id.

    Sets the id discriminator for the next widgets. Use [Iris.PopId] to remove it.
]=]
function Iris.PushId(id: ID)
    assert(typeof(id) == "string", "Iris expected Iris.PushId id to PushId to be a string.")

    Internal._pushedId = tostring(id)
end

--[=[
    @function PopId
    @within Iris

    Removes the id discriminator set by [Iris.PushId].
]=]
function Iris.PopId()
    Internal._pushedId = nil
end

--[=[
    @function SetNextWidgetId
    @within Iris
    @param id ID -- custom id.

    Sets the id for the next widget. Useful for using [Iris.Append] on the same widget.
    ```lua
    Iris.SetNextWidgetId("demo_window")
    Iris.Window({ "Window" })
        Iris.Text({ "Text one placed here." })
    Iris.End()

    -- later in the code

    Iris.SetNextWidgetId("demo_window")
    Iris.Window()
        Iris.Text({ "Text two placed here." })
    Iris.End()

    -- both text widgets will be placed under the same window despite being called separately.
    ```
]=]
function Iris.SetNextWidgetID(id: ID)
    Internal._nextWidgetId = id
end

--[[
    -----------------------
        [SECTION] State
    -----------------------
]]

--[=[
    @function State
    @within Iris
    @param initialValue any -- The initial value for the state

    Constructs a new state object, subsequent ID calls will return the same object
    :::info
    Iris.State allows you to create "references" to the same value while inside your UI drawing loop.
    For example:
    ```lua
    Iris:Connect(function()
        local myNumber = 5;
        myNumber = myNumber + 1
        Iris.Text({"The number is: " .. myNumber})
    end)
    ```
    This is problematic. Each time the function is called, a new myNumber is initialized, instead of retrieving the old one.
    The above code will always display 6.
    ***
    Iris.State solves this problem:
    ```lua
    Iris:Connect(function()
        local myNumber = Iris.State(5)
        myNumber:set(myNumber:get() + 1)
        Iris.Text({"The number is: " .. myNumber})
    end)
    ```
    In this example, the code will work properly, and increment every frame.
    :::
]=]
function Iris.State(initialValue: any): State
    local ID: ID = Internal._getID(2)
    if Internal._states[ID] then
        return Internal._states[ID]
    end
    Internal._states[ID] = {
        value = initialValue,
        ConnectedWidgets = {},
        ConnectedFunctions = {},
    } :: any
    setmetatable(Internal._states[ID], Internal.StateClass)
    return Internal._states[ID]
end

--[=[
    @function WeakState
    @within Iris
    @param initialValue any -- The initial value for the state

    Constructs a new state object, subsequent ID calls will return the same object, except all widgets connected to the state are discarded, the state reverts to the passed initialValue
]=]
function Iris.WeakState(initialValue: any): State
    local ID: ID = Internal._getID(2)
    if Internal._states[ID] then
        if next(Internal._states[ID].ConnectedWidgets) == nil then
            Internal._states[ID] = nil
        else
            return Internal._states[ID]
        end
    end
    Internal._states[ID] = {
        value = initialValue,
        ConnectedWidgets = {},
        ConnectedFunctions = {},
    } :: any
    setmetatable(Internal._states[ID], Internal.StateClass)
    return Internal._states[ID]
end

--[=[
    @function ComputedState
    @within Iris
    @param firstState State -- State to bind to.
    @param onChangeCallback function -- callback which should return a value transformed from the firstState value
        
    Constructs a new State object, but binds its value to the value of another State.
    :::info
    A common use case for this constructor is when a boolean State needs to be inverted:
    ```lua
    Iris.ComputedState(otherState, function(newValue)
        return not newValue
    end)
    ```
    :::
]=]
function Iris.ComputedState(firstState: State, onChangeCallback: (firstState: any) -> any): State
    local ID: ID = Internal._getID(2)

    if Internal._states[ID] then
        return Internal._states[ID]
    else
        Internal._states[ID] = {
            value = onChangeCallback(firstState.value),
            ConnectedWidgets = {},
            ConnectedFunctions = {},
        } :: any
        firstState:onChange(function(newValue: any)
            Internal._states[ID]:set(onChangeCallback(newValue))
        end)
        setmetatable(Internal._states[ID], Internal.StateClass)
        return Internal._states[ID]
    end
end

--[=[
    @function ShowDemoWindow
    @within Iris

    ShowDemoWindow is a function which creates a Demonstration window. this window contains many useful utilities for coders,
    and serves as a refrence for using each part of the library. Ideally, the DemoWindow should always be available in your UI.
    It is the same as any other callback you would connect to Iris using [Iris.Connect]
    ```lua
    Iris:Connect(Iris.ShowDemoWindow)
    ```
]=]
Iris.ShowDemoWindow = demoWindow(Iris)

widgets(Internal)
api(Iris)

return Iris