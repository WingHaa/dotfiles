import { App } from "astal/gtk3"
import Calendar from "./widgets/Calendar"

App.start({
    css: "./style.css",
    main() {
        Calendar();
    }
})
