from django import forms

from Comment.models import Comment


class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = [
            'content',
            'rating',

        ]
class DashCommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = [
            'content',
            'rating',
            'parent',
            'comment_for'
        ]
