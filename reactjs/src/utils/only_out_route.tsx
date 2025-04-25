import React, {useContext} from 'react';
import {Navigate, Outlet} from 'react-router-dom';
import AuthContext from '../context/auth_context';

const OnlyOutRoute = () => {
    /*
    * Usage: prevents the logged-in user to visit the screen
    * */

    let {user} = useContext(AuthContext);
    // If authorized, return an outlet that will render child elements
    // If not, return element that will navigate to login page
    return user ? <Navigate to="/"/> : <Outlet/>;
}

export default OnlyOutRoute