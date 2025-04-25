import React, {useContext, useState} from "react";
import Modal from "../../components/modal/modal";
import Links from "../../utils/links";
import axios from "axios";
import CustomToast from "../../components/toastify/toastify";
import AuthContext from "../../context/auth_context";
import {AddressModel} from "../../models/address_model";
import {Link} from "react-router-dom";

interface CatProps {
    address: AddressModel;
    loadingAccess: React.Dispatch<React.SetStateAction<boolean>>;
    refresh: () => void;
}


const AddressItem: React.FC<CatProps> = ({address, loadingAccess, refresh}) => {
    const [showDelModal, setShowDelModal] = useState(false);

    let {accessToken} = useContext(AuthContext);

    const defaultFuncs = () => {
        return (
            <>
                <Link to={'/settings/address/' + address.uuid} className='btn yellow-btn'>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path d="M384 224v184a40 40 0 01-40 40H104a40 40 0 01-40-40V168a40 40 0 0140-40h167.48"
                              fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                              stroke-width="32"/>
                        <path className='fill'
                              d="M459.94 53.25a16.06 16.06 0 00-23.22-.56L424.35 65a8 8 0 000 11.31l11.34 11.32a8 8 0 0011.34 0l12.06-12c6.1-6.09 6.67-16.01.85-22.38zM399.34 90L218.82 270.2a9 9 0 00-2.31 3.93L208.16 299a3.91 3.91 0 004.86 4.86l24.85-8.35a9 9 0 003.93-2.31L422 112.66a9 9 0 000-12.66l-9.95-10a9 9 0 00-12.71 0z"/>
                    </svg>
                </Link>
                <button className='btn red-btn' onClick={() => setShowDelModal(true)}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path d="M112 112l20 320c.95 18.49 14.4 32 32 32h184c17.67 0 30.87-13.51 32-32l20-320"
                              fill="none"
                              stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="32"/>
                        <path stroke="#fff" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32"
                              d="M80 112h352"/>
                        <path
                            d="M192 112V72h0a23.93 23.93 0 0124-24h80a23.93 23.93 0 0124 24h0v40M256 176v224M184 176l8 224M328 176l-8 224"
                            fill="none" stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="32"/>
                    </svg>
                </button>
            </>
        )
    }

    const deleteHandle = async () => {
        try {
            const link: string = Links.addressLink(address.uuid);
            const response = await axios.delete(
                link,
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`  // Include this line if you are using token-based authentication
                    }
                }
            ).then((res) => {
                loadingAccess(false);
                return res;
            });
            refresh();
            CustomToast.success();
            setShowDelModal(false);
            return response.data;
        } catch (error) {
            CustomToast.error();
            loadingAccess(false);
            setShowDelModal(false);
            throw error;
        }
    }

    return (
        <li>
            <div className='right'>
                <h2>{address.title}</h2>
            </div>
            <div className='left'>
                {defaultFuncs()}
            </div>
            <Modal show={showDelModal} handleClose={() => {
                setShowDelModal(false);
            }}>
                <h2>آیا از حذف کردن این آیتم مطمئن اید؟</h2>
                <div className='row' style={{columnGap: "20px"}}>
                    <button className='btn red-btn' onClick={deleteHandle}>بله</button>
                    <button className='btn green-btn' onClick={() => setShowDelModal(false)}>خیر</button>
                </div>
            </Modal>
        </li>
    )
}

export default AddressItem;