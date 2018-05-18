use ast::ExprKind::*;
use ast::Type::*;
use ast::*;
use exprs;

pub fn translate_stream_types(expr: &mut Expr<Type>) {
    expr.transform(&mut translate_stream_types_impl)
}

fn translate_stream_types_impl(expr: &mut Expr<Type>) -> Option<Expr<Type>> {
    match expr.kind {
        Next(ref mut iterable) => {
            let stream_type = match iterable.ty {
                Stream(ref elem_ty) => Some(elem_ty.as_ref().clone()),
                _ => None,
            };
            let mut stream = iterable.as_mut().take();
            stream.ty = translate_stream_type(&stream.ty);
            stream_type.map(|elem_ty| exprs::cudf_pointer_expr(stream, Vec::new(), elem_ty).unwrap())
        }
        _ => None,
    }
}

fn translate_stream_type(ty: &Type) -> Type {
    match ty {
        Stream(ref elem_ty) => Function(vec![Unit], elem_ty.clone()),
        Builder(BuilderKind::StreamAppender(ref elem_ty), _) => Function(vec![elem_ty.as_ref().clone()], Box::new(Unit)),
        _ => ty.clone(),
    }
}
