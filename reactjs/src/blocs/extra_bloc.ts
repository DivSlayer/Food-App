import Links from "../utils/links";
import {ExtraModel} from "../models/extra_model";

export async function ExtrasBloc(accessToken: string, uuid?: string | null): Promise<ExtraModel[] | null> {
    const link: string = Links.extraLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['extras'];
        return transaction_json_list.map((item) => {
            return ExtraModel.fromJson(item);
        });
    }
    return null;
}