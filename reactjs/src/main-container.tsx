import {useLocation} from "react-router-dom";
import CustomSwitch from "./custom_switch";
import {defaultRoutes} from "./models/route_model";

export default function MainContainer() {
    const location = useLocation();

    // Determine the class based on the current path
    const getClassForMainContainer = (): boolean | null => {
        for (let i = 0; i < defaultRoutes.length; i++) {
            let route = defaultRoutes[i];
            let fullPath = route.pathMaker();
            let searchIndex = fullPath.search(':');
            let currentLocation = location.pathname;
            if (searchIndex !== -1) {
                currentLocation = currentLocation.substring(0, searchIndex);
                fullPath = fullPath.substring(0, searchIndex);
            }
            if (fullPath === currentLocation) {
                return route.useFixedClass;
            }
        }
        return null;
    };
    return (
        <>
            <div className={'main-container' + (getClassForMainContainer() === true ? ' fixed' : '')}>
                <CustomSwitch>
                    {defaultRoutes.map((item) => item.RouterMaker())}
                </CustomSwitch>
            </div>

        </>
    )
}