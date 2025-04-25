import './_register.scss';
import FormGroup from "../../components/forms/form-group";
import {Link} from "react-router-dom";

const Register = () => {

    return (
        <div className='register-section animate__animated animate__fadeInLeft'>
            <div className='register-card'>
                <div className='register-icon'>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path
                            d="M414.11 153.82C429.66 264.4 345.85 357.09 282.54 366s-169.48-57.5-185-167.68a159.82 159.82 0 11316.53-44.49z"
                            fill="none" stroke="currentColor" strokeMiterlimit="10" strokeWidth="32"/>
                        <path
                            d="M236.06 308.05c-32.83-13-67.08-43.1-82.27-85.46M367.7 495.78c-32.83-13-63.31-40.06-78.5-82.41"
                            fill="none" stroke="currentColor" strokeLinecap="round" strokeMiterlimit="10"
                            strokeWidth="32"/>
                        <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              strokeWidth="32" d="M266.71 368.21l-9.17 49.61 63.31-8.9-22.49-45.16-31.65 4.45z"/>
                    </svg>
                </div>
                <div className='register-header'>
                    <h1>ثبت نام</h1>
                </div>
                <form className='register-form'>
                    <div className='inputs'>
                        <FormGroup label='نام کاربری' name='username'/>
                        <FormGroup label='شماره تماس' name='phone'/>
                        <FormGroup label='رمز ورود' name='password1'/>
                        <FormGroup label='تکرار رمز ورود' name='password2'/>
                    </div>
                    <div className='funcs'>
                        <button className='register-btn btn yellow-btn'>ورود</button>
                        <div className='form-control help-item'>
                            <p>حساب کاربری دارید؟</p>
                            <Link to='/login'>ورود به حساب کاربری</Link>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    )
}

export default Register