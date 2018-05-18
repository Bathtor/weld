use super::error::*;
use ast::ExprKind::*;
use ast::IterKind::*;
use ast::Type::*;
use ast::*;

pub fn infer_iterators(expr: &mut Expr<Type>) -> WeldResult<()> {
    expr.transform_kind(&mut infer_iterators_impl);
    Ok(())
}

fn infer_iterators_impl(expr: &mut Expr<Type>) -> Option<ExprKind<Type>> {
    match expr.kind {
        For {
            iters: ref mut itrs,
            builder: ref mut b,
            func: ref mut f,
        } => {
            if all_known(itrs) {
                None
            } else {
                let newiters: Vec<Iter<Type>> = itrs
                    //.into_iter()
                    .drain(..)
                    .map(|mut i| match i.kind {
                        UnknownIter => match i.data.ty {
                            Stream(_) => Iter {
                                data: i.data.take(),
                                start: None,
                                end: None,
                                stride: None,
                                kind: NextIter,
                                shape: None,
                                strides: None,
                            },
                            _ => Iter {
                                data: i.data.take(),
                                start: None,
                                end: None,
                                stride: None,
                                kind: ScalarIter,
                                shape: None,
                                strides: None,
                            },
                        },
                        _ => i,
                    })
                    .collect();
                Some(For {
                    iters: newiters,
                    builder: b.take(),
                    func: f.take(),
                })
            }
        }
        _ => None,
    }
}

fn all_known(iters: &Vec<Iter<Type>>) -> bool {
    !iters.iter().any(|i| i.kind == UnknownIter)
}
