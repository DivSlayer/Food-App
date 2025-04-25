import {Route} from "react-router-dom";
import OnlyOutRoute from "../utils/only_out_route";
import PrivateRoute from "../utils/private_route";
import Home from "../screens/Home/home";
import Search from "../screens/Search/search";
import CategoryScreen from "../screens/Category/category_screen";
import Login from "../screens/Login/login";
import Register from "../screens/Register/register";
import Coverage from "../screens/Coverage/coverage";
import AddFood from "../screens/Food/add_food";
import FoodList from "../screens/Food/food_list";
import SingleFood from "../screens/Food/single_food";
import TransactionList from "../screens/Transaction/transaction_list";
import SingleTransaction from "../screens/Transaction/single_transaction";
import ExtraList from "../screens/Extra/extra_list";
import SingleExtra from "../screens/Extra/single_extra";
import AddExtra from "../screens/Extra/add_extra";
import SingleInstruction from "../screens/Instruction/single_instruction";
import InstructionsList from "../screens/Instruction/instruction_list";
import AddInstruction from "../screens/Instruction/add_instruction";
import AddressScreen from "../screens/Adrdesss/address_screen";
import SingleAddress from "../screens/Adrdesss/single_address";
import Comments from "../screens/Comment/comments";
import SettingsScreen from "../screens/Settings/settings_screen";
import IncomeScreen from "../screens/IncomeChart/income_screen";
import RestaurantScreen from "../screens/Restaurant/restaurant_screen";

interface RouteProps {
    parent?: string | null;
    path: string;
    element: JSX.Element;
    isPrivate?: boolean;
    useFixedClass?: boolean;

}

class RouteModel {
    parent?: string | null;
    path: string;
    element: JSX.Element;
    isPrivate: boolean = true;
    useFixedClass: boolean = false;

    constructor({
                    parent,
                    path,
                    element,
                    isPrivate,
                    useFixedClass
                }: RouteProps) {
        this.parent = parent;
        this.path = path;
        this.element = element;
        this.isPrivate = isPrivate ?? true;
        this.useFixedClass = useFixedClass ?? false;
    }

    RouterMaker(): React.ReactElement {
        let path = this.parent ? `/${this.parent}/${this.path}` : "/" + this.path;
        return (
            <Route path={path} element={this.isPrivate ? <PrivateRoute/> : <OnlyOutRoute/>}>
                <Route path={path} element={this.element}/>
            </Route>
        )
    }

    pathMaker() {
        if (this.path !== "") {
            return this.parent ? `/${this.parent}/${this.path}` : "/" + this.path;
        } else {
            return this.parent ? `/${this.parent}` : "/";
        }
    }
}

export const defaultRoutes: RouteModel[] = [
    new RouteModel({path: '', element: <Home/>}),
    new RouteModel({path: 'search', element: <Search/>, useFixedClass: true}),
    new RouteModel({path: 'category', element: <CategoryScreen/>}),

    // Auth URLs
    new RouteModel({path: 'login', element: <Login/>, isPrivate: false}),
    new RouteModel({path: 'register', element: <Register/>, isPrivate: false}),

    // Restaurant Settings
    new RouteModel({parent: 'settings', path: '', element: <SettingsScreen/>}),
    new RouteModel({parent: 'settings', path: 'coverage', element: <Coverage/>, useFixedClass: true}),
    new RouteModel({parent: 'settings', path: 'address', element: <AddressScreen/>, useFixedClass: true}),
    new RouteModel({parent: 'settings', path: 'address/:uuid', element: <SingleAddress/>, useFixedClass: true}),
    new RouteModel({parent: 'settings', path: 'address/add', element: <SingleAddress/>, useFixedClass: true}),


    //Comment URLS
    new RouteModel({parent: 'comments', path: '', element: <Comments/>, useFixedClass: true}),

    //Income
    new RouteModel({parent: 'income', path: '', element: <IncomeScreen/>, useFixedClass: true}),

    //Restaurant
    new RouteModel({parent: 'restaurant', path: '', element: <RestaurantScreen/>, useFixedClass: true}),

    // Food URLs
    new RouteModel({parent: 'food', path: 'add', element: <AddFood/>}),
    new RouteModel({parent: "food", path: 'list', element: <FoodList/>}),
    new RouteModel({parent: "food", path: ':uuid', element: <SingleFood/>}),

    // Transaction URLs
    new RouteModel({parent: 'transaction', path: 'list', element: <TransactionList/>}),
    new RouteModel({parent: 'transaction', path: ':serial', element: <SingleTransaction/>}),

    // Extras URLs
    new RouteModel({parent: 'extra', path: 'list', element: <ExtraList/>}),
    new RouteModel({parent: 'extra', path: ':uuid', element: <SingleExtra/>}),
    new RouteModel({parent: 'extra', path: 'add', element: <AddExtra/>}),

    // Instruction URLs
    new RouteModel({parent: 'instruction', path: 'list', element: <InstructionsList/>}),
    new RouteModel({parent: 'instruction', path: 'add', element: <AddInstruction/>}),
    new RouteModel({parent: 'instruction', path: ':uuid', element: <SingleInstruction/>}),
];

