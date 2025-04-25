import './_login.scss';
import FormGroup from "../../components/forms/form-group";
import {Link} from "react-router-dom";
import React, {useContext, useEffect, useState} from "react";
import EyeIcon from '../../assets/svgs/eye-outline.svg';
import EyeOffIcon from '../../assets/svgs/eye-off-outline.svg';
import Loader from "../../components/loader/loader";
import AuthContext from "../../context/auth_context";

const Login = () => {
    const [showingPass, setShowingPass] = useState(false);
    const [eyeIcon, setEyeIcon] = useState(EyeIcon);
    const [isSending, setIsSending] = useState(false);
    const [error, setError] = useState<string | null>();
    const [phone, setPhone] = useState<string | null>();
    const [password, setPass] = useState<string | null>();
    let {loginUser} = useContext(AuthContext);
    useEffect(() => {
        setEyeIcon(showingPass ? EyeIcon : EyeOffIcon);
    }, [showingPass]);


    const eyeClick = (e: React.TouchEvent | React.MouseEvent) => {
        e.preventDefault();
        setShowingPass(prev => !prev);
    }
    const formSubmit = async (e: React.FormEvent | React.MouseEvent | React.TouchEvent) => {
        e.preventDefault();
        if (phone != null && password != null) {
            setIsSending(true);
            let res = await loginUser(phone, password);
            if (typeof res === "string") {
                setIsSending(false);
                setError(res)
            }
            console.log(res);
        }
    }
    return (
        <div className='login-section animate__animated animate_
        _fadeInLeft'>
            <div className='login-card'>
                <div className='login-icon'>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <circle cx="256" cy="448" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="256" cy="320" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <path d="M288 192a32 32 0 11-32-32 32 32 0 0132 32z" fill="none" stroke="currentColor"
                              strokeMiterlimit="10" strokeWidth="32"/>
                        <circle cx="256" cy="64" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="384" cy="320" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="384" cy="192" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="384" cy="64" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="128" cy="320" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="128" cy="192" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                        <circle cx="128" cy="64" r="32" fill="none" stroke="currentColor" strokeMiterlimit="10"
                                strokeWidth="32"/>
                    </svg>
                </div>
                <div className='login-header'>
                    <h1>ورود</h1>
                </div>
                <form className='login-form' onSubmit={formSubmit}>
                    <div className='inputs'>
                        <FormGroup label='شماره همراه' key='phone' name='phone' update={(value) => setPhone(value)}/>
                        <FormGroup label='رمز ورود' key='password' name='password'
                                   keyboardType={showingPass ? 'text' : 'password'} suffix={eyeIcon}
                                   suffixClick={eyeClick} update={(value) => setPass(value)}/>
                    </div>
                    <p className='error-text'>
                        {error}
                    </p>
                    <div className='funcs'>
                        <button className='login-btn btn yellow-btn' onClick={formSubmit}>ورود</button>
                        <div className='form-control help-item'>
                            <p>رمز عبور خودرا فراموش کرده اید؟</p>
                            <a href=''>بازیابی رمز عبور</a>
                        </div>
                        <div className='form-control help-item'>
                            <p>حساب کاربری ندارید؟</p>
                            <Link to='/register'>ساخت حساب</Link>
                        </div>
                    </div>
                </form>

            </div>
            {
                isSending ? <Loader/> : <></>
            }
        </div>
    )
}

export default Login