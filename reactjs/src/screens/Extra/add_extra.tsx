import Loader from "../../components/loader/loader";
import EditIcon from "../../assets/svgs/create-outline.svg";
import FormGroup from "../../components/forms/form-group";
import Modal from "../../components/modal/modal";
import CustomToast from "../../components/toastify/toastify";
import React, {ChangeEvent, useContext, useRef, useState} from "react";
import {useNavigate} from "react-router-dom";
import {ExtraModel} from "../../models/extra_model";
import AuthContext from "../../context/auth_context";
import Links from "../../utils/links";
import axios from "axios";
import PriceFormatter from "../../utils/price_formatter";


interface FileDetails {
    name: string;
    size: number;
    type: string;
    icon: string;
}

const AddExtra = () => {
    const [extra, setExtra] = useState<ExtraModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [price, setPrice] = useState<string | null>();
    const [extraData, setExtraData] = useState<Record<string, any>>(
        {
            name: null,
        }
    );
    const [showPicModal, setShowPicModal] = useState<boolean>(false);
    const [fileDetails, setFileDetails] = useState<FileDetails | null>();
    const [selectedFile, setSelectedFile] = useState<File | null>();
    const [uploadError, setUploadError] = useState<string | null>();

    const history = useNavigate();
    const fileInputRef = useRef<HTMLInputElement>(null);
    const formRef = useRef<HTMLFormElement>(null);
    let {accessToken} = useContext(AuthContext);

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
                }
            }
        }

    }

    const displayPic =()=>{
        if(selectedFile){
            const reader = new FileReader();
            reader.onload = function (e) {
                setFileDetails((prev) => {
                    return {
                        name: selectedFile.name,
                        size: selectedFile.size,
                        type: selectedFile.type,
                        icon: e.target!.result as string,
                    };
                });
            }
            reader.readAsDataURL(selectedFile);
        }
    }

    const handleFormSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        setIsLoading(true)
        if (formRef.current) {
            const form = formRef.current;
            const formData = new FormData();

            // Collect form inputs
            const inputs = form.querySelectorAll('input');
            const textAreas = form.querySelectorAll('textarea');
            const select = form.querySelectorAll('select');

            inputs.forEach(input => {
                formData.append(input.name, input.value);
            });

            textAreas.forEach(textarea => {
                formData.append(textarea.name, textarea.value);
            });

            select.forEach(input => {
                formData.append(input.name, input.value);
            })
            // Check if a file is selected and append it to formData
            if (selectedFile) {
                formData.append('icon', selectedFile);
            }

            formData.append('price', price?.replaceAll(',', '') ?? '0');
            try {
                const link: string = Links.extraLink() + "/";
                const response = await axios.post(link, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data', // Use multipart/form-data for file uploads
                        'Authorization': `Bearer ${accessToken}`, // Include token if using authentication
                    },
                }).then((res) => {
                    if (res.status.toString().charAt(0) === '2') {
                        history('/extras-list')
                    }
                    return res;
                });

                setExtra(ExtraModel.fromJson(response.data));
            } catch (error) {
                setIsLoading(false);
            }
        }
    };

    return (
        <>
            <div className='single-extra animate__animated animate__fadeInDown'>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <div className="details-holder">

                            <div className='image' style={{backgroundImage: `url(${fileDetails ? fileDetails!.icon : ""})`, backgroundColor: '#fff'}}>
                                <div className='edit-btn' onClick={() => {
                                    setShowPicModal(true);
                                }}>
                                    <img src={EditIcon} alt='Edit'/>
                                </div>

                            </div>
                            <form className='form' ref={formRef} onSubmit={handleFormSubmit}>
                                <FormGroup label='نام مخلفات' key='name' name='name' value={extraData.name}
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
                                                        onClick={() => {
                                                            displayPic();
                                                            setShowPicModal(false);
                                                        }}>تایید</button> : <></>}
                            </div>
                        </Modal>
                    </>
                }
            </div>
            {CustomToast.container()}
        </>
    )
}

export default AddExtra;