// Import necessary interfaces
export interface IAccount {
    first_name: string; // Assuming Account has an ID
    last_name: string; // Assuming Account has a username
    profile: string; // Assuming Account has a username
}

export interface ICommentFor {
    restaurant?: any; // Replace `any` with the actual structure of the restaurant object
    food?: any; // Replace `any` with the actual structure of the food object
}

export interface IComment {
    uuid: string;
    content: string;
    commentFor: ICommentFor | null; // Updated to reflect the structure returned by `get_comment_for`
    commentFrom: IAccount; // Reference to the user who made the comment
    rating: number;
    parentId?: string; // Optional for replies
    replies?: IComment[]; // Array of replies
}

export default class CommentModel implements IComment {
    uuid: string;
    content: string;
    commentFor: ICommentFor | null; // Updated type
    commentFrom: IAccount;
    rating: number;
    parentId?: string;
    replies: IComment[];

    constructor(
        uuid: string,
        content: string,
        commentFor: ICommentFor | null,
        commentFrom: IAccount,
        rating: number,
        parentId?: string,
        replies: IComment[] = []
    ) {
        this.uuid = uuid;
        this.content = content;
        this.commentFor = commentFor;
        this.commentFrom = commentFrom;
        this.rating = rating;
        this.parentId = parentId;
        this.replies = replies;
    }

    // Method to create a Comment instance from a JSON object
    static fromJSON(data: any): CommentModel {
        const uuid = data.uuid;
        const content = data.content;
        const commentFor: ICommentFor | null = data.comment_for ? data.comment_for : null; // Handle possible null value
        const commentFrom: IAccount = {
            first_name: data.comment_from.first_name,
            last_name: data.comment_from.last_name,
            profile: data.comment_from.profile,
        };
        const rating = data.rating;
        const parentId = data.parent || null;
        const replies = (data.replies || []).map((reply: any) => CommentModel.fromJSON(reply)); // Recursively map replies

        return new CommentModel(uuid, content, commentFor, commentFrom, rating, parentId, replies,);
    }
}