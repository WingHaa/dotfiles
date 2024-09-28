//  ____  _     _      _
// / ___|(_) __| | ___| |__   __ _ _ __
// \___ \| |/ _` |/ _ \ '_ \ / _` | '__|
//  ___) | | (_| |  __/ |_) | (_| | |
// |____/|_|\__,_|\___|_.__/ \__,_|_|
//

// Set App icons
App.addIcons(`${App.configDir}/assets`);

// Calendar Widget
const cld = Widget.Calendar({
    showDayNames: true,
    showDetails: false,
    showHeading: true,
    showWeekNumbers: false,
    className: "cld",
    onDaySelected: ({ date: [y, m, d] }) => {
        print(`${y}. ${m}. ${d}.`);
    },
});

// Sidebar Box
const Calendar = Widget.Box({
    spacing: 8,
    vertical: true,
    className: "calendar",
    children: [
        Widget.Box({
            homogeneous: true,
            className: "row",
            children: [cld],
            css: "min-width:300px",
        }),
    ],
});

// Calendar Window
const CalendarWindow = Widget.Window({
    name: "calendar",
    className: "window",
    anchor: ["top", "right"],
    // Start with hidden window, toggle with ags -t sidebar
    // visible: true,
    visible: false,
    child: Widget.Box({
        css: "padding: 1px;",
        child: Calendar,
    }),
});

// App Configuration
let config = {
    style: "./style.css",
    windows: [CalendarWindow],
    openWindowDelay: {
        calendar: 100,
    },
    closeWindowDelay: {
        calendar: 50,
    },
};

// Run AGS
App.config(config);
