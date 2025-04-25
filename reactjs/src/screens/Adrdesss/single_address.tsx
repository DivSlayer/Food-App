import {useNavigate, useParams} from "react-router-dom";
import React, {useContext, useEffect, useState} from "react";
import Loader from "../../components/loader/loader";
import './single-address.scss';
import FormGroup from "../../components/forms/form-group";
import {AddressModel} from "../../models/address_model";
import Modal from "../../components/modal/modal";
import CustomToast from "../../components/toastify/toastify";
import {AddressBloc} from "../../blocs/address_bloc";
import AuthContext from "../../context/auth_context";
import Links from "../../utils/links";
import axios from "axios";
import CustomMap from "./custom_map";
import {LatLng} from "leaflet";

const SingleAddress = () => {
    const routerParams = useParams();
    const uuid: string | null = routerParams.uuid ?? null;
    const history = useNavigate();
    const [address, setAddress] = useState<AddressModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [addressData, setAddressData] = useState<Record<string, any>>(
        {

            title: null,
            brief_address: null,
            latitude: null,
            longitude: null,
        }
    );

    const [titleError, setTitleError] = useState<string | null>();
    const [briefError, setBriefError] = useState<string | null>();
    const [defaultLat, setDefaultLat] = useState<string | null>();
    const [defaultLong, setDefaultLong] = useState<string | null>();
    const [showDelModal, setShowDelModal] = useState<boolean>(false);
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        if (uuid !== null) {
            fetchAddress();
        } else {
            setIsLoading(false);
            setAddressData({
                title: null,
                brief_address: null,
            });
            setDefaultLat('35.6994');
            setDefaultLong('51.39403');
        }
    }, []);

    useEffect(() => {
        if (address) {
            setAddressData({
                title: address.title,
                brief_address: address.brief_address,
            })
        }
    }, [address]);

    useEffect(() => {
        validate()
    }, [addressData]);

    const fetchAddress = async () => {
        let found_transaction: AddressModel[] | null = await AddressBloc(accessToken ?? "", uuid).then(item => {
            if (item !== null) {
                setDefaultLong(item[0].longitude);
                setDefaultLat(item[0].latitude);

            }
            setIsLoading(false);
            return item;
        });
        if (found_transaction && found_transaction.length > 0) {
            setAddress(found_transaction[0]);
            setAddressData({
                title: found_transaction[0].title,
                brief_address: found_transaction[0].brief_address,
            });
        }
    }

    const deleteHandle = async () => {
        try {
            const link: string = Links.addressLink(uuid);
            const response = await axios.delete(link, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            if (response.status === 200) {
                history('/food-list');
            }
        } catch (error) {
            console.error('Error deleting file:', error);
        }

    }

    const onDragEnd = (position: LatLng) => {
        setAddressData((prev) => {
            return {
                ...prev,
                latitude: position.lat.toString(),
                longitude: position.lng.toString(),
            }
        });
    }

    const validate = (): boolean => {
        let confirmed = true;
        let titleValue = addressData.title ? addressData.title.trim() : null;
        let briefValue = addressData.brief_address ? addressData.brief_address.trim() : null;
        if (titleValue == null || titleValue === "") {
            setTitleError("این فیلد اجباری است!");
            confirmed = false;
        } else {
            setTitleError(null);
        }
        if (briefValue == null || briefValue === "") {
            setBriefError("این فیلد اجباری است!");
            confirmed = false;
        } else {
            setBriefError(null);
        }
        return confirmed;
    }

    const update = async () => {
        let validation = validate();
        if (validation) {
            try {
                const link: string = Links.addressLink(uuid);
                const data = Object.fromEntries(
                    Object.entries(addressData).filter(([key, value]) => value !== null)
                );
                const response = await axios.put(
                    link,
                    data,
                    {
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${accessToken}`  // Include this line if you are using token-based authentication
                        }
                    }
                ).then((res) => {
                    setIsLoading(false);
                    return res;
                });
                setAddress(AddressModel.fromJson(response.data));
                CustomToast.success();
                return response.data;
            } catch (error) {
                CustomToast.error();
                console.error('Error updating food:', error);
                setIsLoading(false);
                throw error;
            }
        }
    }
    return (
        <>

            <div className='single-address animate__animated animate__fadeInDown'>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <CustomMap
                            prevPosition={new LatLng(parseFloat(defaultLat!), parseFloat(defaultLong!))}
                            onDragEnd={onDragEnd}/>
                        <div className="details-holder">
                            <form className='form'>
                                <FormGroup label='عنوان آدرس' key='name' name='name' value={addressData.title}
                                           error={titleError}
                                           update={(value) => {
                                               setAddressData((prev) => {
                                                   return {
                                                       ...prev,
                                                       title: value,
                                                   }
                                               });
                                           }}/>
                                <FormGroup label='جزئیات آدرس' key='details' name='details'
                                           error={briefError}
                                           value={addressData.brief_address}
                                           useTextarea={true}
                                           update={(value) => {
                                               setAddressData((prev) => {
                                                   return {
                                                       ...prev,
                                                       brief_address: value,
                                                   }
                                               });
                                           }}/>

                                <div className='row'>
                                    <button className='btn yellow-btn submit-btn' onClick={(e) => {
                                        e.preventDefault();
                                        update();
                                    }}>ذخیره
                                    </button>
                                </div>
                            </form>
                        </div>
                        {/*Delete Modal*/}
                        <Modal show={showDelModal} handleClose={() => {
                            setShowDelModal(false);
                        }}>
                            <h2>آیا از حذف کردن این آدرس مطمئن اید؟</h2>
                            <div className='row' style={{columnGap: "20px"}}>
                                <button className='btn red-btn' onClick={deleteHandle}>بله</button>
                                <button className='btn green-btn' onClick={() => setShowDelModal(false)}>خیر</button>
                            </div>
                        </Modal>

                    </>
                }
            </div>
            {CustomToast.container()}
        </>
    )
}

export default SingleAddress;