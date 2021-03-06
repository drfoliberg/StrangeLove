SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `strangelove` ;
CREATE SCHEMA IF NOT EXISTS `strangelove` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `strangelove` ;

-- -----------------------------------------------------
-- Table `strangelove`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`users` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(64) NOT NULL,
  `salt` VARCHAR(36) NOT NULL,
  `email` VARCHAR(150) NULL,
  `wallet` VARCHAR(60) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`machines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`machines` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`machines` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NULL,
  `total_slots` INT NULL,
  `installation_date` DATE NULL,
  `motherboard_model` VARCHAR(80) NULL,
  `motherboard_serial_number` VARCHAR(255) NULL,
  `value` DOUBLE NULL,
  `ip_address` VARCHAR(45) NULL,
  `port` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`units`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`units` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`units` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `machine_id` INT NOT NULL,
  `model` VARCHAR(120) NULL,
  `installation_date` DATE NULL,
  `purchase_date` DATE NULL,
  `serial_number` VARCHAR(80) NULL,
  `warranty_expiration_date` DATE NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_units_machine_id_idx` (`machine_id` ASC),
  CONSTRAINT `fk_units_machine_id`
    FOREIGN KEY (`machine_id`)
    REFERENCES `strangelove`.`machines` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`users_units`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`users_units` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`users_units` (
  `user_id` INT NOT NULL,
  `unit_id` INT NOT NULL,
  `share` DECIMAL(3,2) NOT NULL,
  INDEX `fk_users_units_1_idx` (`user_id` ASC),
  INDEX `fk_users_units_unit_id_idx` (`unit_id` ASC),
  PRIMARY KEY (`unit_id`, `user_id`),
  CONSTRAINT `fk_users_units_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `strangelove`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_units_unit_id`
    FOREIGN KEY (`unit_id`)
    REFERENCES `strangelove`.`units` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`stats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`stats` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`stats` (
  `timestamp` INT NOT NULL,
  `device_id` INT NOT NULL,
  `temperature` FLOAT NOT NULL,
  `device_voltage` FLOAT NOT NULL,
  `engine_clock` INT NOT NULL,
  `memory_clock` INT NOT NULL,
  `fan_rpm` INT NOT NULL,
  `hardware_errors` INT NOT NULL,
  `shares_rejected` INT NOT NULL,
  `shares_accepted` INT NOT NULL,
  `hashrate` INT NOT NULL,
  `intensity` INT NOT NULL,
  `time_since_last_work` INT NOT NULL,
  `time_since_last_valid_work` INT NOT NULL,
  `shares_since_last_record` INT NOT NULL,
  `invalid_shares_since_last_record` INT NOT NULL,
  INDEX `fk_stats_units1_idx` (`device_id` ASC),
  PRIMARY KEY (`timestamp`, `device_id`),
  CONSTRAINT `fk_stats_units1`
    FOREIGN KEY (`device_id`)
    REFERENCES `strangelove`.`units` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`stats_machines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`stats_machines` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`stats_machines` (
  `machine_id` INT NOT NULL,
  `timestamp` INT NOT NULL,
  `uptime` INT NULL,
  `load_avg` FLOAT NULL,
  INDEX `fk_stats_machines_idx` (`machine_id` ASC),
  PRIMARY KEY (`timestamp`, `machine_id`),
  CONSTRAINT `fk_stats_machines`
    FOREIGN KEY (`machine_id`)
    REFERENCES `strangelove`.`machines` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `strangelove`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strangelove`.`log` ;

CREATE TABLE IF NOT EXISTS `strangelove`.`log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `timestamp` MEDIUMTEXT NULL,
  `error_code` TINYINT NULL,
  `level` TINYINT NULL,
  `error_message` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
