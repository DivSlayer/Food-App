import React, {useContext, useState} from "react";
import CategoryModel from "../../models/category_model";
import TrashIcon from '../../assets/svgs/trash-outline.svg';
import EditIcon from '../../assets/svgs/create-outline.svg';
import FormGroup from "../../components/forms/form-group";
import Links from "../../utils/links";
import axios from "axios";
import CustomToast from "../../components/toastify/toastify";
import AuthContext from "../../context/auth_context";


interface AddProps {
    onCancel: () => void;
    loadingAccess: React.Dispatch<React.SetStateAction<boolean>>;
    refresh: () => void;
}

const AddCategoryItem: React.FC<AddProps> = ({onCancel, loadingAccess, refresh}) => {
    const [title, setTitle] = useState<string | null>();
    const [error, setError] = useState<string | null>();

    let {accessToken} = useContext(AuthContext);

    const editFuncs = () => {
        return (
            <>
                <button className='btn green-btn' onClick={() => edit()}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                              stroke-width="32" d="M416 128L192 384l-96-96"/>
                    </svg>
                </button>
                <button className='btn red-btn' onClick={reset}>
                    <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                        <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                              stroke-width="32" d="M368 368L144 144M368 144L144 368"/>
                    </svg>
                </button>
            </>
        )
    }

    const validate = (): boolean => {
        if (title != null && error !== "") {
            setError('این فیلد اجباری است!')
            return false;
        }
        return true;
    }

    const edit = async () => {
        let res = validate();
        if (res) {
            loadingAccess(true);
            try {
                let data = {
                    'title': title
                }
                const link: string = Links.categoryLink();
                const response = await axios.post(
                    link,
                    data,
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
                return response.data;
            } catch (error) {
                CustomToast.error();
                loadingAccess(false);
                throw error;
            }
        }
    }

    const reset = () => {
        setTitle(null);
        setError(null);
        onCancel();
    }

    return (
        <li>
            <div className='right'>
                <FormGroup label='نام' key='title' name='title' value={title}
                           update={(value) => setTitle(value)}/>
                {error ? <p className='error-text'>{error}</p> : null}

            </div>
            <div className='left'>
                {editFuncs()}
            </div>
        </li>
    )
}

export default AddCategoryItem;