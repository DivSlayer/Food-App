import './address_screen.scss'
import Loader from "../../components/loader/loader";
import React, {useContext, useEffect, useState} from "react";
import AuthContext from "../../context/auth_context";
import AddressItem from "./address_item";
import {AddressModel} from "../../models/address_model";
import {AddressBloc} from "../../blocs/address_bloc";
import FormGroup from "../../components/forms/form-group";
import checkIcon from "../../assets/svgs/checkmark-outline.svg";
import {Link} from "react-router-dom";


export default function AddressScreen() {
    const [isLoading, setIsLoading] = useState(true);
    const [isAdding, setIsAdding] = useState(false);
    const [addresses, setAddresses] = useState<AddressModel[]>([]);

    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        await AddressBloc(accessToken!).then((data) => {

            if (data && data.length > 0) {
                setAddresses(data);
            }
            setIsLoading(false);
        });
    }

    const handleAdd = async () => {

    }

    return (
        <>
            <div className='address_screen'>
                <div className='header'>
                    <h1>آدرس ها</h1>
                    <Link className='btn green-btn' to='/settings/address/add'>اضافه کردن</Link>
                </div>
                {
                    isLoading ? <Loader/> : <ul>
                        {/*{isAdding? <>*/}
                        {/*    <li>*/}
                        {/*        <div className='right'>*/}
                        {/*            <FormGroup label='عنوان آدرس' name={'name'} />*/}
                        {/*        </div>*/}
                        {/*        <div className='left'>*/}
                        {/*            <button className='btn green-btn'>*/}
                        {/*                <svg xmlns="http://www.w3.org/2000/svg" className="ionicon"*/}
                        {/*                     viewBox="0 0 512 512">*/}
                        {/*                    <path fill="none" stroke="currentColor" stroke-linecap="round"*/}
                        {/*                          stroke-linejoin="round" stroke-width="32"*/}
                        {/*                          d="M416 128L192 384l-96-96"/>*/}
                        {/*                </svg>*/}
                        {/*            </button>*/}
                        {/*        </div>*/}
                        {/*    </li>*/}

                        {/*</> : <></>}*/}
                        {addresses.map((address) => <AddressItem address={address} loadingAccess={setIsLoading}
                                                                 refresh={fetchCategories}/>)}
                    </ul>
                }

            </div>

        </>
    )
}