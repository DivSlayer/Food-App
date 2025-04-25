import React, { useContext, useEffect } from 'react';
import { Navigate, Outlet, useParams } from 'react-router-dom';
import AuthContext from '../context/auth_context';

const PrivateRoute = ({ PlayingPermission = false, DownloadingPermission = false, mainRoute = null }) => {
    let params = useParams()
    let previous_route = mainRoute !== null ? `/${mainRoute}/${params.slug}` : null;
    let { user } = useContext(AuthContext);

    if (user) {
        // if ((PlayingPermission && user.plan !== null && user.plan.play_available) || (DownloadingPermission && user.plan != null && user.download_available)) {
        //     return <Outlet />
        // }
        return <Outlet />
    }
    if (previous_route !== null) {
        return <Navigate to={'/login?next=' + previous_route} />;
    }
    return <Navigate to='/login' />
}

export default PrivateRoute