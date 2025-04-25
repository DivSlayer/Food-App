import {Bounce, toast, ToastContainer} from "react-toastify";
import React from "react";

export default class CustomToast {

    static success() {
        toast.success('آپدیت شد!', {
            position: "top-right",
            autoClose: 5000,
            hideProgressBar: false,
            closeOnClick: false,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            rtl: true,
            theme: "dark",
            transition: Bounce,
        });
    }
    static error() {
        toast.error('خطایی رخ داده است!', {
            position: "top-right",
            autoClose: 5000,
            hideProgressBar: false,
            closeOnClick: false,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            rtl: true,
            theme: "dark",
            transition: Bounce,
        });
    }

    static container(){
        return <ToastContainer
            position="top-right"
            autoClose={5000}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick={false}
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
            theme="dark"
            style={{fontFamily:"Dana"}}
            toastClassName='toastify'
            transition={Bounce}
        />
    }
}