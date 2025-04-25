import './settings.scss';
import Pizza from "../../assets/vectors/pizza.svg";
import Soda from "../../assets/vectors/soda.svg";
import Mushroom from "../../assets/vectors/mushrooms.svg";
import {Link} from "react-router-dom";

function SettingsScreen() {
    return (
        <div className='profile section animate__animated animate__fadeInDown'>
            <div className='header'>
                <h1>رستوران</h1>
                <button className='btn red-btn'>
                    <span>خروج</span>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path
                            d="M304 336v40a40 40 0 01-40 40H104a40 40 0 01-40-40V136a40 40 0 0140-40h152c22.09 0 48 17.91 48 40v40M368 336l80-80-80-80M176 256h256"
                            fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                            strokeWidth="32"/>
                    </svg>
                </button>
            </div>
            <ul className='section-items'>
                <li>
                    <Link to='/category'>
                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                            <circle cx="160" cy="96" r="48" fill="none" stroke="currentColor" strokeLinecap="round"
                                    strokeLinejoin="round" strokeWidth="32"/>
                            <circle cx="160" cy="416" r="48" fill="none" stroke="currentColor" strokeLinecap="round"
                                    strokeLinejoin="round" strokeWidth="32"/>
                            <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                                  strokeWidth="32" d="M160 368V144"/>
                            <circle cx="352" cy="160" r="48" fill="none" stroke="currentColor" strokeLinecap="round"
                                    strokeLinejoin="round" strokeWidth="32"/>
                            <path d="M352 208c0 128-192 48-192 160" fill="none" stroke="currentColor"
                                  strokeLinecap="round"
                                  strokeLinejoin="round" strokeWidth="32"/>
                        </svg>
                        <span>دسته بندی ها</span>
                    </Link>
                </li>
                <li>
                    <Link to='/about'>
                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                            <path
                                d="M336 64h32a48 48 0 0148 48v320a48 48 0 01-48 48H144a48 48 0 01-48-48V112a48 48 0 0148-48h32"
                                fill="none" stroke="#131313" strokeLinecap="round" strokeWidth="32"/>
                            <rect x="176" y="32" width="160" height="64" rx="26.13" ry="26.13" fill="none"
                                  stroke="#131313" strokeLinecap="round" strokeWidth="32"/>
                        </svg>
                        <span>سفارش ها</span>
                    </Link>
                </li>
                <li>
                    <Link to='/settings/address'>

                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                            <path
                                d="M313.27 124.64L198.73 51.36a32 32 0 00-29.28.35L56.51 127.49A16 16 0 0048 141.63v295.8a16 16 0 0023.49 14.14l97.82-63.79a32 32 0 0129.5-.24l111.86 73a32 32 0 0029.27-.11l115.43-75.94a16 16 0 008.63-14.2V74.57a16 16 0 00-23.49-14.14l-98 63.86a32 32 0 01-29.24.35zM328 128v336M184 48v336"
                                fill="none" stroke="#131313" strokeLinecap="round" strokeLinejoin="round"
                                strokeWidth="32"/>
                        </svg>
                        <span>آدرس ها</span>
                    </Link>
                </li>
                <li>
                    <Link to='/settings/coverage'>
                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                            <path
                                d="M388 288a76 76 0 1076 76 76.24 76.24 0 00-76-76zM124 288a76 76 0 1076 76 76.24 76.24 0 00-76-76z"
                                fill="none" stroke="#131313" strokeMiterlimit="10" strokeWidth="32"/>
                            <path fill="none" stroke="#131313" strokeLinecap="round" strokeLinejoin="round"
                                  strokeWidth="32" d="M256 360v-86l-64-42 80-88 40 72h56"/>
                            <path d="M320 136a31.89 31.89 0 0032-32.1A31.55 31.55 0 00320.2 72a32 32 0 10-.2 64z"/>
                        </svg>
                        <span>محدوده خدمت رسانی</span>
                    </Link>
                </li>
            </ul>
        </div>
    )
}

export default SettingsScreen;