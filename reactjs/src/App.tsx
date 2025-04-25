import './App.scss';
import {BrowserRouter as Router, } from "react-router-dom";
import Navbar from "./Navbar/navbar";
import MobileNavbar from "./Navbar/mobile_navbar";
import {AuthProvider} from "./context/auth_context";

import MainContainer from "./main-container";

function App() {

    return (
        <Router>
            <AuthProvider>
                <MobileNavbar/>
                <div className='main'>
                    <Navbar/>
                    <MainContainer/>
                </div>
            </AuthProvider>
        </Router>
    );
}

export default App;
