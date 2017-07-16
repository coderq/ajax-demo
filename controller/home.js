exports.index = async (ctx) => {
    ctx.status = 200;
    await ctx.render('upload/index', {
        csrf: ctx.csrf
    });
};