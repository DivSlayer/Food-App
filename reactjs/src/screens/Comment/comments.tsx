import './comments.scss';
import {useContext, useEffect, useState} from "react";
import {CommentBloc} from "../../blocs/comment_bloc";
import AuthContext from "../../context/auth_context";
import CommentModel from "../../models/comment_model";
import Loader from "../../components/loader/loader";
import CommentItem from "./comment_item";

export default function Comments() {
    const [isLoading, setIsLoading] = useState(true);
    const [comments, setComments] = useState<CommentModel[]>([]);

    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchComments();
    }, []);

    const fetchComments = async () => {
        await CommentBloc(accessToken!).then((data) => {
            setIsLoading(false);
            if (data) {
                setComments(data)
            }
        });
    }

    return (
        <div className='comment-screen'>
            <div className='header animate__animated animate__fadeInDown'>
                <h1>کامنت ها</h1>
            </div>
            <div className='comments-holder  animate__animated animate__fadeInUp'>
                {isLoading ? <Loader/> : <div className='comments-list'>
                    {comments.map((comment: CommentModel) => (
                        <CommentItem item={comment} refresh={() => {
                            setIsLoading(true);
                            fetchComments();
                        }}/>
                    ))}
                </div>}
            </div>
        </div>
    )
}