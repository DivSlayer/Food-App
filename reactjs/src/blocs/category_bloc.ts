import Links from "../utils/links";
import CategoryModel from "../models/category_model";

export async function CategoryBloc(accessToken: string, uuid?: string | null): Promise<CategoryModel[] | null> {
    const link: string = Links.categoryLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['categories'];
        return transaction_json_list.map((item) => {
            return CategoryModel.fromJSON(item);
        });
    }
    return null;
}