import {useNavigate, useParams} from "react-router-dom";
import React, {ChangeEvent, useContext, useEffect, useRef, useState} from "react";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import './restaurant-screen.scss';
import axios from "axios";
import Links from "../../utils/links";
import FormGroup from "../../components/forms/form-group";
import {RestaurantModel} from "../../models/restaurant_model";
import EditIcon from '../../assets/svgs/create-outline.svg';
import Modal from "../../components/modal/modal";
import {CategoryBloc} from "../../blocs/category_bloc";
import CategoryModel from "../../models/category_model";
import {Bounce, toast, ToastContainer} from "react-toastify";
import CustomToast from "../../components/toastify/toastify";
import {RestaurantBloc} from "../../blocs/restaurant_bloc";

interface FileDetails {
    name: string;
    size: number;
    type: string;
}

const RestaurantScreen = () => {
    const routerParams = useParams();
    const [restaurant, setRestaurant] = useState<RestaurantModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [currentUpdating, setCurrentUpdating] = useState<string | null>();

    const [restaurantData, setRestaurantData] = useState<Record<string, any>>(
        {
            name: null,
        }
    );

    const [showPicModal, setShowPicModal] = useState<boolean>(false);
    const [fileDetails, setFileDetails] = useState<FileDetails | null>();
    const [selectedFile, setSelectedFile] = useState<File | null>();
    const [uploadError, setUploadError] = useState<string | null>();

    const fileInputRef = useRef<HTMLInputElement>(null);
    const formRef = useRef<HTMLFormElement>(null);

    const uuid: string = routerParams.uuid ?? "";
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchRestaurant();
    }, []);

    useEffect(() => {
        if (restaurant) {
            setRestaurantData({name: restaurant.name});
        }
    }, [restaurant]);

    const fetchRestaurant = async () => {
        let found_transaction: RestaurantModel | null = await RestaurantBloc(accessToken ?? "", uuid).then(item => {
            setIsLoading(false);
            return item;
        });
        if (found_transaction) {
            setRestaurant(found_transaction);
            setRestaurantData({
                name: found_transaction.name,
            })
        }
    }

    const uploadPic = (e: ChangeEvent<HTMLInputElement>) => {
        if (fileInputRef.current) {
            fileInputRef.current.click();
            const file = e.target.files?.[0] || null;
            if (file) {
                const validExtensions = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validExtensions.includes(file.type)) {
                    setUploadError('فرمت فایل قابل قبول نیست!');
                    setSelectedFile(null);
                    setFileDetails(null);
                    return;
                } else {
                    setSelectedFile(file);
                    setUploadError(null);
                    setFileDetails({
                        name: file.name,
                        size: file.size,
                        type: file.type,
                    });

                }
            }
        }

    }

    const handleFileUpload = async () => {
        if (selectedFile && currentUpdating) {
            const formData = new FormData();
            formData.append(currentUpdating!, selectedFile);
            try {
                const link: string = Links.restaurantLink +"/";
                await axios.put(link, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        Authorization: `Bearer ${accessToken}`,
                    },
                }).then((item) => {
                    setShowPicModal(false);
                    setRestaurant(RestaurantModel.fromJson(item.data));
                    return item;
                });
                CustomToast.success();
            } catch (error) {
                CustomToast.error();
                console.error('Error uploading file:', error);
            }
        }
    };

    const updateForm = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        if (formRef.current) {
            let data: Record<string, any> = {};
            let form = formRef.current;
            let inputs = form.querySelectorAll('input');
            let text_areas = form.querySelectorAll('textarea');
            const select = form.querySelectorAll('select');

            inputs.forEach(input => {
                data[input.name] = input.value;
            });
            text_areas.forEach(textarea => {
                data[textarea.name] = textarea.value;
            })
            select.forEach(input => {
                data[input.name] = input.value;
            })
            try {
                const link: string = Links.restaurantLink + "/";
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
                setRestaurant(RestaurantModel.fromJson(response.data));
                CustomToast.success();
                return response.data;
            } catch (error) {
                CustomToast.error();
                console.error('Error updating restaurant:', error);
                setIsLoading(false);
                throw error;
            }
        }
    }

    return (
        <>

            <div className='single-restaurant animate__animated animate__fadeInLeft'>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <div className="details-holder">
                            <div className='pics-holder'>
                                <div className='image-holder'>
                                    <h2 className='title'>تصویر پس زمینه</h2>
                                    <div className='image' style={{backgroundImage: `url(${restaurant?.image})`}}>
                                        <div className='edit-btn' onClick={() => {
                                            setShowPicModal(true);
                                            setCurrentUpdating('image');
                                        }}>
                                            <img src={EditIcon} alt='Edit'/>
                                        </div>
                                    </div>
                                </div>
                                <div className='image-holder'>
                                    <h2 className='title'>تصویر لوگو</h2>
                                    <div className='image' style={{backgroundImage: `url(${restaurant?.logo})`}}>
                                        <div className='edit-btn' onClick={() => {
                                            setShowPicModal(true);
                                            setCurrentUpdating('logo');
                                        }}>
                                            <img src={EditIcon} alt='Edit'/>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <form className='form' ref={formRef} onSubmit={updateForm}>
                                <FormGroup label='نام رستوران' key='name' name='name' value={restaurantData.name}
                                           update={(value) => {
                                               setRestaurantData((prev) => {
                                                   return {
                                                       ...prev,
                                                       name: value,
                                                   }
                                               });
                                           }}/>
                                <div className='row'>
                                    <button className='btn yellow-btn submit-btn'
                                            type='submit'>ذخیره
                                    </button>
                                </div>
                            </form>
                        </div>
                        {/*Photo Modal*/}
                        <Modal show={showPicModal} handleClose={() => {
                            setShowPicModal(false);
                            setCurrentUpdating(null);
                        }}>
                            <h2>ویرایش تصویر</h2>
                            <div className='row' style={{rowGap: "20px", flexDirection: 'column'}}>
                                <input type='file' hidden={true} ref={fileInputRef} onChange={uploadPic}/>
                                <button className='btn yellow-btn' type='button' style={{width: '100%'}}
                                        onClick={() => {
                                            if (fileInputRef.current) {
                                                fileInputRef.current.click();
                                            }
                                        }}>
                                    آپلود تصویر
                                </button>
                                <p style={{fontSize: '12px'}}>
                                    فرمت های قابل قبول: {currentUpdating === 'logo' ? 'png, jpg, svg' : 'png, jpg'}
                                </p>
                                {fileDetails ? <p style={{fontSize: '12px'}}>
                                    نام فایل : {fileDetails?.name}
                                </p> : <></>}
                                {uploadError ? <p className='red-color' style={{fontSize: '12px'}}>
                                    خطا : {uploadError}
                                </p> : <></>}
                                {selectedFile ? <button className='btn green-btn' style={{fontSize: "12px"}}
                                                        onClick={handleFileUpload}>تایید</button> : <></>}
                            </div>
                        </Modal>
                    </>
                }
            </div>
            {CustomToast.container()}
        </>
    )
}

export default RestaurantScreen;