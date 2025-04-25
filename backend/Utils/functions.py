import math
from random import randint

from django.utils.crypto import get_random_string
import qrcode
from qrcode.image.styles.moduledrawers.svg import SvgPathCircleDrawer
from qrcode.image import svg


def get_uuid():
    return get_random_string(15)


def generate_qrcode_svg(data):
    qr = qrcode.QRCode(image_factory=qrcode.image.svg.SvgPathImage, box_size=40)
    qr.add_data(data)
    qr.make(fit=True)
    img = qr.make_image(attrib={'class': 'some-css-class'}, module_drawer=SvgPathCircleDrawer())
    return img.to_string(encoding='unicode')


def get_random_num(length=4):
    number = randint(1000, 9999)
    return number


def get_time_difference(seconds, first_datetime):
    to_minute = seconds / 60
    to_hours = seconds / 60 / 60
    to_days = seconds / 60 / 60 / 24
    if to_minute < 60:
        return f"{math.floor(to_minute)} دقیقه" + " پیش "
    if to_hours < 24:
        return f"{math.floor(to_hours)} ساعت" + " پیش "
    if to_days <= 7:
        return f"{math.floor(to_days)} روز" + " پیش "
    return first_datetime.strftime("%Y-%m-%d %H:%M")

