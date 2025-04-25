import {useRef} from "react";
import {NavLink} from "react-router-dom";
import './mobile_navbar.scss';
import {navSections} from "../models/nav_section";

const MobileNavbar = () => {
    const menu = useRef();
    window.addEventListener('scroll', () => {
        menu.current.classList.remove("animate__animated");
        menu.current.classList.remove(" animate__fadeInRight");
    });
    const moreClick =
        (e) => {
            e.preventDefault();
            if (menu.current != null) {
                let menuElement = menu.current;
                menuElement.classList.toggle('expand');
            }
        }
    return (
        <div className='mobile-navbar animate__animated animate__fadeInRight' ref={menu}>
            <div className='menu-burger'>
                <a href='' onClick={moreClick}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <rect x="48" y="48" width="176" height="176" rx="20" ry="20" fill="none"
                              stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32"/>
                        <rect x="288" y="48" width="176" height="176" rx="20" ry="20" fill="none"
                              stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32"/>
                        <rect x="48" y="288" width="176" height="176" rx="20" ry="20" fill="none"
                              stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32"/>
                        <rect x="288" y="288" width="176" height="176" rx="20" ry="20" fill="none"
                              stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32"/>
                    </svg>
                </a>
                <p>منو</p>
            </div>
            <div className='navs-holder'>
                {navSections.map((item,index) => {
                    return <div className={item.name} key={index}>
                        <ul className='navs'>
                            {item.items.map((nav,index2) => {
                                return <li className='nav-item' key={index2}>
                                    <NavLink to={nav.link}>
                                        {nav.svg}
                                    </NavLink>
                                    <p>
                                        {nav.label}
                                    </p>
                                </li>;
                            })}
                        </ul>
                    </div>;
                })}
            </div>
        </div>
    )
}

export default MobileNavbar;