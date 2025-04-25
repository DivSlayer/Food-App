import {useNavigate, useParams} from "react-router-dom";
import React, {ChangeEvent, useContext, useEffect, useRef, useState} from "react";
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
import {CategoryBloc} from "../../blocs/category_bloc";
import CategoryModel from "../../models/category_model";
import CustomToast from "../../components/toastify/toastify";

interface FileDetails {
    name: string;
    size: number;
    type: string;
}

const SingleFood = () => {
    const routerParams = useParams();
    const [food, setFood] = useState<FoodModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [price, setPrice] = useState<string | null>();
    const [foodData, setFoodData] = useState<Record<string, any>>(
        {
            name: null,
            preparation_time: null,
            details: null,
        }
    );
    const [showDelModal, setShowDelModal] = useState<boolean>(false);
    const [showPicModal, setShowPicModal] = useState<boolean>(false);
    const [categories, setCategories] = useState<CategoryModel[]>([]);
    const history = useNavigate();
    const formRef = useRef<HTMLFormElement>(null);

    const uuid: string = routerParams.uuid ?? "";
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchFood();
        fetchCategories();
    }, []);

    const fetchFood = async () => {
        let found_food: FoodModel[] | null = await FoodBloc(accessToken ?? "", uuid).then(item => {
            setIsLoading(false);
            return item;
        });
        if (found_food && found_food.length > 0) {
            setFood(found_food[0]);
            setPrice(PriceFormatter(found_food[0].price ?? 0));
            setFoodData({
                name: found_food[0].name,
                preparation_time: found_food[0].preparationTime,
                details: found_food[0].details,
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

    const deleteHandle = async () => {
        try {
            const link: string = Links.foodLink(uuid);
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
                const link: string = Links.foodLink(uuid);
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
                setFood(FoodModel.fromJson(response.data));
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

                            <div className='image' style={{backgroundImage: `url(${food?.image})`}}>
                                <div className='edit-btn' onClick={() => {
                                    setShowPicModal(true);
                                }}>
                                    <img src={EditIcon} alt='Edit'/>
                                </div>

                            </div>
                            <form className='form' ref={formRef} onSubmit={updateForm}>
                                <FormGroup label='نام غذا' key='name' name='name' value={foodData.name}
                                           update={(value) => {
                                               setFoodData((prev) => {
                                                   return {
                                                       ...prev,
                                                       name: value,
                                                   }
                                               });
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
                                           }}/> <FormGroup label='دسته بندی' key='category'
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
                                    categories.map((item) => {
                                        return <option key={item.pk} value={item.pk.toString()}
                                                       selected={item.pk === food?.category}
                                        >{item.title}</option>
                                    })
                                }
                            </FormGroup>
                                <div className='sizes'>
                                    <span className='label'>سایز ها</span>
                                    <ul className='sizes-holder'>
                                        {food!.sizes.map((size) => {
                                            return <li>
                                                <div className='right'>
                                                    <h2>{size.name}</h2>
                                                    <span>{size.details}</span>
                                                </div>
                                                <div className='middle'>
                                                    <p>{PriceFormatter(size.price)} تومان</p>
                                                </div>
                                                <div className='left'>
                                                    <button className='btn yellow-btn'>
                                                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon"
                                                             viewBox="0 0 512 512">
                                                            <path
                                                                d="M384 224v184a40 40 0 01-40 40H104a40 40 0 01-40-40V168a40 40 0 0140-40h167.48"
                                                                fill="none" stroke="currentColor" stroke-linecap="round"
                                                                stroke-linejoin="round" stroke-width="32"/>
                                                            <path
                                                                d="M459.94 53.25a16.06 16.06 0 00-23.22-.56L424.35 65a8 8 0 000 11.31l11.34 11.32a8 8 0 0011.34 0l12.06-12c6.1-6.09 6.67-16.01.85-22.38zM399.34 90L218.82 270.2a9 9 0 00-2.31 3.93L208.16 299a3.91 3.91 0 004.86 4.86l24.85-8.35a9 9 0 003.93-2.31L422 112.66a9 9 0 000-12.66l-9.95-10a9 9 0 00-12.71 0z"
                                                                fill='#fff'/>
                                                        </svg>
                                                    </button>
                                                    <button className='btn red-btn'>
                                                        <svg xmlns="http://www.w3.org/2000/svg" className="ionicon"
                                                             viewBox="0 0 512 512">
                                                            <path
                                                                d="M112 112l20 320c.95 18.49 14.4 32 32 32h184c17.67 0 30.87-13.51 32-32l20-320"
                                                                fill="none"
                                                                stroke="#fff" stroke-linecap="round"
                                                                stroke-linejoin="round" stroke-width="32"/>
                                                            <path stroke="#fff" stroke-linecap="round"
                                                                  stroke-miterlimit="10" stroke-width="32"
                                                                  d="M80 112h352"/>
                                                            <path
                                                                d="M192 112V72h0a23.93 23.93 0 0124-24h80a23.93 23.93 0 0124 24h0v40M256 176v224M184 176l8 224M328 176l-8 224"
                                                                fill="none" stroke="#fff" stroke-linecap="round"
                                                                stroke-linejoin="round" stroke-width="32"/>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </li>
                                        })}
                                    </ul>
                                </div>
                                <div className='row'>
                                    <button className='btn yellow-btn submit-btn'
                                            type='submit'>ذخیره
                                    </button>
                                </div>
                            </form>
                        </div>
                        {/*Delete Modal*/}
                        {/*<Modal show={showDelModal} handleClose={() => {*/}
                        {/*    setShowDelModal(false);*/}
                        {/*}}>*/}
                        {/*    <h2>آیا از حذف کردن این غذا مطمئن اید؟</h2>*/}
                        {/*    <div className='row' style={{columnGap: "20px"}}>*/}
                        {/*        <button className='btn red-btn' onClick={deleteHandle}>بله</button>*/}
                        {/*        <button className='btn green-btn' onClick={() => setShowDelModal(false)}>خیر</button>*/}
                        {/*    </div>*/}
                        {/*</Modal>*/}


                    </>
                }
            </div>
            {CustomToast.container()}
        </>
    )
}

export default SingleFood;