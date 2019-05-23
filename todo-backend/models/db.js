
module.exports.params = {
  dbname: process.env.DATABASE_NAME,
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  params: {
      host: process.env.DATABASE_SVC,
      dialect: 'mysql',
  }
};
