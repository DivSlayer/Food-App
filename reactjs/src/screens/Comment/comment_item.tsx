import CommentModel, {IComment} from "../../models/comment_model";
import ReplySvg from '../../assets/svgs/arrow-redo-outline.svg';
import FormGroup from "../../components/forms/form-group";
import {useContext, useEffect, useState} from "react";
import {RestaurantModel} from "../../models/restaurant_model";
import {FoodModel} from "../../models/food_model";
import {Link} from "react-router-dom";
import Links from "../../utils/links";
import axios from "axios";
import {ExtraModel} from "../../models/extra_model";
import CustomToast from "../../components/toastify/toastify";
import AuthContext from "../../context/auth_context";


interface props {
    item: CommentModel | IComment;
    isReply?: boolean;
    refresh: () => void;
    firstLevelCommentFor?: string;
}

export default function CommentItem({item, isReply = false, refresh, firstLevelCommentFor}: props) {
    const [isReplying, setIsReplying] = useState(false);
    const [validated, setValidated] = useState(false);
    const [comment, setComment] = useState<CommentModel | IComment>(item);
    const [validateError, setValidateError] = useState<string | null>();
    const [replyContent, setReplyContent] = useState<string | null>();

    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        if (isReplying) {
            validate();
        }
    }, [isReplying, replyContent]);

    const validate = () => {
        if (replyContent && replyContent.trim().length > 0) {
            setValidated(true);
            setValidateError(null);
        } else {
            setValidated(false);
            setValidateError('این فیلد اجباری است!');
        }
    }

    const buildCommentFor = () => {
        if (comment.commentFor) {
            let commentFor: RestaurantModel | FoodModel = comment.commentFor?.food ?? comment.commentFor?.restaurant;
            let link = comment.commentFor?.food ? '/food/' : '/restaurant/';
            return <Link to={link + commentFor.uuid} className='comment-for'>
                <span style={{fontSize: "12px"}}>برای: </span>
                <div className='img' style={{backgroundImage: `url(${commentFor.image})`}}></div>
                <h3 className='name'>{commentFor.name}</h3>
            </Link>
        }

    }

    const reply = async () => {
        if (validated && isReplying) {
            try {
                const link: string = Links.commentLink() + "/";
                let data = {
                    'content': replyContent,
                    'parent': comment.uuid,
                    'comment_for': comment.commentFor ? comment.commentFor.food?.uuid ?? comment.commentFor.restaurant.uuid : firstLevelCommentFor,
                }
                await axios.post(link, data, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        Authorization: `Bearer ${accessToken}`,
                    },
                }).then((res) => {
                    refresh();
                    return res;
                });
                CustomToast.success();
            } catch (error) {
                CustomToast.error();
            }
        } else if (!isReplying) {
            setIsReplying(true);
        }
    }

    const marginSize = isReply ? '20px' : '0px';
    const marginTopSize = isReply ? '30px' : '0px';
    const paddingSize = isReply ? '0px' : '20px';
    return (
        <div className='comment-item' style={{marginRight: marginSize, marginTop: marginTopSize, padding: paddingSize}}>
            {isReply ? <span className='is-reply'>پاسخ:</span> : null}
            <div style={{width: '100%'}}>
                <div className='user-holder'>
                    <div className='img' style={{backgroundImage: `url(${comment.commentFrom.profile})`}}/>
                    <h3>{comment.commentFrom.first_name} {comment.commentFrom.last_name}</h3>
                </div>
                <p>{comment.content}</p>
                {buildCommentFor()}
                <div className='reply-sec'>
                    <button className='btn yellow-btn reply-btn' onClick={reply}>
                        {isReplying ? <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                                <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="32" d="M416 128L192 384l-96-96"/>
                            </svg> :
                            <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512">
                                <path d="M448 256L272 88v96C103.57 184 64 304.77 64 424c48.61-62.24 91.6-96 208-96v96z"
                                      fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="32"/>
                            </svg>
                        }
                    </button>
                    {isReplying ? <FormGroup label='پاسخ' name='reply'
                                             error={validateError}
                                             update={(value) => {
                                                 setReplyContent(value);
                                             }}

                    /> : null}

                </div>
                <div className="reply-holder">
                    {comment.replies ? comment.replies.map(reply => (
                        <CommentItem item={reply} isReply={true} refresh={refresh}
                                     firstLevelCommentFor={firstLevelCommentFor ?? comment.commentFor!.food?.uuid ?? comment.commentFor?.restaurant.uuid}/>
                    )) : null}
                </div>
            </div>

            {CustomToast.container()}
        </div>
    )
}