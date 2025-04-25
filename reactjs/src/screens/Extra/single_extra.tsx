import {useNavigate, useParams} from "react-router-dom";
import React, {ChangeEvent, FormEventHandler, useContext, useEffect, useRef, useState} from "react";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import './single-extra.scss';
import PriceFormatter from "../../utils/price_formatter";
import axios from "axios";
import Links from "../../utils/links";
import FormGroup from "../../components/forms/form-group";
import {ExtraModel} from "../../models/extra_model";
import EditIcon from '../../assets/svgs/create-outline.svg';
import Modal from "../../components/modal/modal";
import {TransactionModel} from "../../models/transaction_model";
import {ExtrasBloc} from "../../blocs/extra_bloc";
import {Bounce, ToastContainer} from "react-toastify";
import CustomToast from "../../components/toastify/toastify";

interface FileDetails {
    name: string;
    size: number;
    type: string;
}

const SingleExtra = () => {
    const routerParams = useParams();
    const [extra, setExtra] = useState<ExtraModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [price, setPrice] = useState<string | null>();
    const [extraData, setExtraData] = useState<Record<string, any>>(
        {
            name: null,
        }
    );
    const [showDelModal, setShowDelModal] = useState<boolean>(false);
    const [showPicModal, setShowPicModal] = useState<boolean>(false);
    const [fileDetails, setFileDetails] = useState<FileDetails | null>();
    const [selectedFile, setSelectedFile] = useState<File | null>();
    const [uploadError, setUploadError] = useState<string | null>();

    const history = useNavigate();
    const fileInputRef = useRef<HTMLInputElement>(null);
    const formRef = useRef<HTMLFormElement>(null);

    const uuid: string = routerParams.uuid ?? "";
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchExtra();
    }, []);

    const fetchExtra = async () => {
        let found_transaction: ExtraModel[] | null = await ExtrasBloc(accessToken ?? "", uuid).then(item => {
            setIsLoading(false);
            return item;
        });
        if (found_transaction && found_transaction.length > 0) {
            setExtra(found_transaction[0]);
            setPrice(PriceFormatter(found_transaction[0].price ?? 0));
            setExtraData({
                name: found_transaction[0].name,
            })
        }
    }

    const updatePrice = (value: string) => {
        value = value.replaceAll(/[^0-9]/g, '');
        let extractedNum = parseInt(value);
        if (!isNaN(extractedNum)) {
            setPrice(PriceFormatter(extractedNum));

        } else {
            setPrice('0');
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
        if (selectedFile) {
            const formData = new FormData();
            formData.append('image', selectedFile);
            try {
                const link: string = Links.extraLink(uuid);
                const response = await axios.put(link, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        Authorization: `Bearer ${accessToken}`,
                    },
                }).then((item) => {
                    setShowPicModal(false);
                    setExtra(ExtraModel.fromJson(item.data));
                    return item;
                })
                CustomToast.success();
                console.log('File uploaded successfully:', response.data);
            } catch (error) {
                CustomToast.error();
                console.error('Error uploading file:', error);
            }
        }
    };

    const deleteHandle = async () => {
        try {
            const link: string = Links.extraLink(uuid);
            const response = await axios.delete(link, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            if (response.status.toString().charAt(0) === "2") {
                history('/extras-list');
            }
        } catch (error) {
            console.error('Error deleting file:', error);
        }

    };

    const updateForm = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        if (formRef.current) {
            let data: Record<string, any> = {};
            let form = formRef.current;
            let inputs = form.querySelectorAll('input');
            let text_areas = form.querySelectorAll('textarea');
            inputs.forEach(input => {
                data[input.name] = input.value;
            });
            text_areas.forEach(textarea => {
                data[textarea.name] = textarea.value;
            });
            data['price'] = parseFloat(price?.replaceAll(',', '') ?? '0');
            try {
                const link: string = Links.extraLink(uuid);
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
                setExtra(ExtraModel.fromJson(response.data));
                console.log(extra!.icon);
                CustomToast.success();
                return response.data;
            } catch (error) {
                CustomToast.error();
                console.error('Error updating extra:', error);
                setIsLoading(false);
                throw error;
            }
        }
    }

    return (
        <>
            <div className='single-extra animate__animated animate__fadeInDown'>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <div className="funcs">
                            <button className="btn red-btn delete-button" onClick={() => {
                                setShowDelModal(true);
                            }}>
                                <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                                    <path
                                        d="M112 112l20 320c.95 18.49 14.4 32 32 32h184c17.67 0 30.87-13.51 32-32l20-320"
                                        fill="none"
                                        stroke="#fff" stroke-linecap="round" stroke-linejoin="round" stroke-width="32"/>
                                    <path stroke="#fff" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32"
                                          d="M80 112h352"/>
                                    <path
                                        d="M192 112V72h0a23.93 23.93 0 0124-24h80a23.93 23.93 0 0124 24h0v40M256 176v224M184 176l8 224M328 176l-8 224"
                                        fill="none" stroke="#fff" stroke-linecap="round" stroke-linejoin="round"
                                        stroke-width="32"/>
                                </svg>
                            </button>
                        </div>
                        <div className="details-holder">

                            <div className='image' style={{backgroundImage: `url(${extra?.icon})`}}>
                                <div className='edit-btn' onClick={() => {
                                    setShowPicModal(true);
                                }}>
                                    <img src={EditIcon} alt='Edit'/>
                                </div>

                            </div>
                            <form className='form' ref={formRef} onSubmit={updateForm}>
                                <FormGroup label='نام' key='name' name='name' value={extraData.name}
                                           update={(value) => {
                                               setExtraData((prev) => {
                                                   return {
                                                       ...prev,
                                                       name: value,
                                                   }
                                               });
                                           }}/>
                                <FormGroup label='قیمت  (تومان)' key='price' name='price'
                                           value={price}
                                           update={(value) => {
                                               updatePrice(value);
                                           }}/>
                                <div className='row'>
                                    <button className='btn yellow-btn submit-btn'
                                            type='submit'>ذخیره
                                    </button>
                                </div>
                            </form>
                        </div>
                        {/*Delete Modal*/}
                        <Modal show={showDelModal} handleClose={() => {
                            setShowDelModal(false);
                        }}>
                            <h2>آیا از حذف کردن این غذا مطمئن اید؟</h2>
                            <div className='row' style={{columnGap: "20px"}}>
                                <button className='btn red-btn' onClick={deleteHandle}>بله</button>
                                <button className='btn green-btn' onClick={() => setShowDelModal(false)}>خیر</button>
                            </div>
                        </Modal>

                        {/*Photo Modal*/}
                        <Modal show={showPicModal} handleClose={() => {
                            setShowPicModal(false);
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
                                    فرمت های قابل قبول: png, jpg, gif
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

export default SingleExtra;