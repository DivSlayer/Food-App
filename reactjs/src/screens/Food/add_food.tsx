import {useNavigate, useParams} from "react-router-dom";
import React, {ChangeEvent, FormEventHandler, useContext, useEffect, useRef, useState} from "react";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import './single-food.scss';
import PriceFormatter from "../../utils/price_formatter";
import axios from "axios";
import Links from "../../utils/links";
import FormGroup from "../../components/forms/form-group";
import {FoodModel} from "../../models/food_model";
import {FoodBloc} from "../../blocs/food_bloc";
import EditIcon from '../../assets/svgs/create-outline.svg';
import Modal from "../../components/modal/modal";
import {TransactionModel} from "../../models/transaction_model";
import CategoryModel from "../../models/category_model";
import {CategoryBloc} from "../../blocs/category_bloc";

interface FileDetails {
    name: string;
    size: number;
    type: string;
    image: string | null;
}

const AddFood = () => {
    const routerParams = useParams();
    const [food, setFood] = useState<FoodModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [price, setPrice] = useState<string | null>();
    const [categories, setCategories] = useState<CategoryModel[]>([]);
    const [foodData, setFoodData] = useState<Record<string, any>>(
        {
            name: null,
            preparation_time: null,
            details: null,
            category_id: null,
        }
    );
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
        fetchCategories()
    }, []);

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
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        setFileDetails((prev) => {
                            return {
                                name: file.name,
                                size: file.size,
                                type: file.type,
                                image: e.target!.result as string,
                            };
                        });
                    }
                    reader.readAsDataURL(file);
                    setSelectedFile(file);
                    setUploadError(null);
                }
            }
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
                formData.append('image', selectedFile);
            }

            try {
                const link: string = Links.foodLink();
                const response = await axios.post(link, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data', // Use multipart/form-data for file uploads
                        'Authorization': `Bearer ${accessToken}`, // Include token if using authentication
                    },
                }).then((res) => {
                    if (res.status.toString().charAt(0) === '2') {
                        history('/food-list')
                    }
                    return res;
                });

                setFood(FoodModel.fromJson(response.data));
            } catch (error) {
                setIsLoading(false);
            }
        }
    };

    const fetchCategories = async () => {
        let blocRes = await CategoryBloc(accessToken!);
        if (blocRes != null) {
            setCategories(blocRes);
        }
    }
    return (
        <>
            <div className='single-food animate__animated animate__fadeInDown'>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <div className="details-holder">

                            <div className='image'
                                 style={{
                                     backgroundImage: `url(${fileDetails ? fileDetails!.image : ""})`,
                                     backgroundColor: "#fff"
                                 }}>
                                <div className='edit-btn' onClick={() => {
                                    setShowPicModal(true);
                                }}>
                                    <img src={EditIcon} alt='Edit'/>
                                </div>

                            </div>
                            <form className='form' ref={formRef} onSubmit={handleFormSubmit}>
                                <FormGroup label='نام غذا' key='name' name='name' value={foodData.name}
                                           update={(value) => {
                                               setFoodData((prev) => {
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

                                <FormGroup label='ترکیبات' key='details' name='details'
                                           value={foodData.details}
                                           useTextarea={true}
                                           update={(value) => {
                                               setFoodData((prev) => {
                                                   return {
                                                       ...prev,
                                                       details: value,
                                                   }
                                               });
                                           }}/>
                                <FormGroup label='زمان آماده سازی (دقیقه)' key='preparation_time'
                                           name='preparation_time'
                                           value={typeof foodData.preparation_time === 'number' ? foodData.preparation_time.toString() :
                                               foodData.preparation_time
                                           }
                                           keyboardType={'number'}
                                           update={(value) => {
                                               setFoodData((prev) => {
                                                   return {
                                                       ...prev,
                                                       preparation_time: value,
                                                   }
                                               });
                                           }}/>
                                <FormGroup label='دسته بندی' key='category'
                                           name='category'
                                           useSelect={true}
                                           update={(value) => {
                                               setFoodData((prev) => {
                                                   return {
                                                       ...prev,
                                                       category_id: value,
                                                   }
                                               });
                                           }}>

                                    {
                                        categories.map((item)=>{
                                            return <option key={item.pk} value={item.pk.toString()}>{item.title}</option>
                                        })
                                    }
                                </FormGroup>
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
                                                            setShowPicModal(false)
                                                        }}>تایید</button> : <></>}
                            </div>
                        </Modal>
                    </>
                }
            </div>
        </>
    )
}

export default AddFood;