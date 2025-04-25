import Links from "../utils/links";
import CommentModel from "../models/comment_model";

export async function CommentBloc(accessToken: string, uuid?: string | null): Promise<CommentModel[] | null> {
    const link: string = Links.commentLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: [] = json_converted['comments'];
        return transaction_json_list.map((item) => {
            return CommentModel.fromJSON(item);
        });
    }
    return null;
}