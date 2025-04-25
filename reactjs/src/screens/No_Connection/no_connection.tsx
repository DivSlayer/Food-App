import './no_connection.scss';
import {ButtonIcon} from "../../components/buttons/button_icon";
import RefreshVector from '../../assets/vectors/refresh.svg';
import {useNavigate} from "react-router-dom";

export const NoConnection = () => {
    const history = useNavigate();
    return (
        <div className='no-connection'>
            <div className='container'>
                <img src={RefreshVector} alt='refresh_vector' className='vector'/>
                <h1>اتصال برقرار نشد!</h1>
                <ButtonIcon label='تلاش مجدد' classname='blue-btn' onClick={(e) => {
                    e.preventDefault();
                    console.log('hello');
                    window.location.reload();
                }}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path d="M320 146s24.36-12-64-12a160 160 0 10160 160" fill="none" stroke="currentColor"
                              strokeLinecap="round"
                              strokeMiterlimit="10" strokeWidth="32"/>
                        <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32"
                              d="M256 58l80 80-80 80"/>
                    </svg>
                </ButtonIcon>
            </div>
        </div>
    )
}